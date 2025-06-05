//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import OpenTelemetryApi
import OpenTelemetryProtocolExporterCommon
import OpenTelemetrySdk

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public func defaultOltpHttpLoggingEndpoint() -> URL {
  URL(string: "http://localhost:4318/v1/logs")!
}

public class OtlpHttpLogExporter: OtlpHttpExporterBase, LogRecordExporter {
  var pendingLogRecords: [ReadableLogRecord] = []
  private let exporterLock = Lock()
  internal var exporterMetrics: IExporterMetrics?

  override public init(endpoint: URL = defaultOltpHttpLoggingEndpoint(),
                       config: OtlpConfiguration = OtlpConfiguration(),
                       useSession: URLSession? = nil,
                       envVarHeaders: [(String, String)]? = EnvVarHeaders.attributes) {
    super.init(endpoint: endpoint,
               config: config,
               useSession: useSession,
               envVarHeaders: envVarHeaders)
  }

  public func export(logRecords: [OpenTelemetrySdk.ReadableLogRecord],
                     explicitTimeout: TimeInterval? = nil) -> OpenTelemetrySdk.ExportResult {
    var sendingLogRecords: [ReadableLogRecord] = []
    exporterLock.withLockVoid {
      pendingLogRecords.append(contentsOf: logRecords)
      sendingLogRecords = pendingLogRecords
      pendingLogRecords = []
    }

    let body =
      Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest.with { request in
        request.resourceLogs = LogRecordAdapter.toProtoResourceRecordLog(
          logRecordList: sendingLogRecords)
      }

    var request = createRequest(body: body, endpoint: endpoint)
    if let headers = envVarHeaders {
      headers.forEach { key, value in
        request.addValue(value, forHTTPHeaderField: key)
      }

    } else if let headers = config.headers {
      headers.forEach { key, value in
        request.addValue(value, forHTTPHeaderField: key)
      }
    }
    exporterMetrics?.addSeen(value: sendingLogRecords.count)
    request.timeoutInterval = min(explicitTimeout ?? TimeInterval.greatestFiniteMagnitude, config.timeout)
    httpClient.send(request: request) { [weak self] result in
      switch result {
      case .success:
        self?.exporterMetrics?.addSuccess(value: sendingLogRecords.count)
      case let .failure(error):
        self?.exporterMetrics?.addFailed(value: sendingLogRecords.count)
        self?.exporterLock.withLockVoid {
          self?.pendingLogRecords.append(contentsOf: sendingLogRecords)
        }
        OpenTelemetry.instance.feedbackHandler?(error.localizedDescription)
      }
    }

    return .success
  }

  public func forceFlush(explicitTimeout: TimeInterval? = nil) -> ExportResult {
    flush(explicitTimeout: explicitTimeout)
  }

  public func flush(explicitTimeout: TimeInterval? = nil) -> ExportResult {
    var exporterResult: ExportResult = .success
    var pendingLogRecords: [ReadableLogRecord] = []
    exporterLock.withLockVoid {
      pendingLogRecords = self.pendingLogRecords
    }

    if !pendingLogRecords.isEmpty {
      let body =
        Opentelemetry_Proto_Collector_Logs_V1_ExportLogsServiceRequest.with { request in
          request.resourceLogs = LogRecordAdapter.toProtoResourceRecordLog(
            logRecordList: pendingLogRecords)
        }
      let semaphore = DispatchSemaphore(value: 0)
      var request = createRequest(body: body, endpoint: endpoint)
      request.timeoutInterval = min(explicitTimeout ?? TimeInterval.greatestFiniteMagnitude, config.timeout)
      if let headers = envVarHeaders {
        headers.forEach { key, value in
          request.addValue(value, forHTTPHeaderField: key)
        }
      } else if let headers = config.headers {
        headers.forEach { key, value in
          request.addValue(value, forHTTPHeaderField: key)
        }
      }
      httpClient.send(request: request) { [weak self] result in
        switch result {
        case .success:
          self?.exporterMetrics?.addSuccess(value: pendingLogRecords.count)
          exporterResult = ExportResult.success
        case let .failure(error):
          self?.exporterMetrics?.addFailed(value: pendingLogRecords.count)
        OpenTelemetry.instance.feedbackHandler?(error.localizedDescription)
          exporterResult = ExportResult.failure
        }
        semaphore.signal()
      }
      semaphore.wait()
    }

    return exporterResult
  }
}
