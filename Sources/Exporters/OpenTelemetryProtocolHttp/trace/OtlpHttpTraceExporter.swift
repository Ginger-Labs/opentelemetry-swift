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

public func defaultOltpHttpTracesEndpoint() -> URL {
  URL(string: "http://localhost:4318/v1/traces")!
}

public class OtlpHttpTraceExporter: OtlpHttpExporterBase, SpanExporter {
  var pendingSpans: [SpanData] = []

  private let exporterLock = Lock()
  internal var exporterMetrics: IExporterMetrics?

  override
  public init(endpoint: URL = defaultOltpHttpTracesEndpoint(),
              config: OtlpConfiguration = OtlpConfiguration(),
              useSession: URLSession? = nil,
              envVarHeaders: [(String, String)]? = EnvVarHeaders.attributes) {
    super.init(endpoint: endpoint,
               config: config,
               useSession: useSession,
               envVarHeaders: envVarHeaders)
  }

  public func export(spans: [SpanData], explicitTimeout: TimeInterval? = nil, completion: ((SpanExporterResultCode) -> Void)?) {
    var sendingSpans: [SpanData] = []
    exporterLock.withLockVoid {
      pendingSpans.append(contentsOf: spans)
      sendingSpans = pendingSpans
      pendingSpans = []
    }

    let body =
      Opentelemetry_Proto_Collector_Trace_V1_ExportTraceServiceRequest.with {
        $0.resourceSpans = SpanAdapter.toProtoResourceSpans(
          spanDataList: sendingSpans)
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
    exporterMetrics?.addSeen(value: sendingSpans.count)
    httpClient.send(request: request) { [weak self] result in
      switch result {
      case .success:
        self?.exporterMetrics?.addSuccess(value: sendingSpans.count)
        completion?(.success)
      case let .failure(error):
        self?.exporterMetrics?.addFailed(value: sendingSpans.count)
        self?.exporterLock.withLockVoid {
          self?.pendingSpans.append(contentsOf: sendingSpans)
        }
        OpenTelemetry.instance.feedbackHandler?(error.localizedDescription)
        completion?(.failure)
      }
    }
  }

  public func flush(explicitTimeout: TimeInterval? = nil)
    -> SpanExporterResultCode {
    var resultValue: SpanExporterResultCode = .success
    var pendingSpans: [SpanData] = []
    exporterLock.withLockVoid {
      pendingSpans = self.pendingSpans
    }
    if !pendingSpans.isEmpty {
      let body =
        Opentelemetry_Proto_Collector_Trace_V1_ExportTraceServiceRequest.with {
          $0.resourceSpans = SpanAdapter.toProtoResourceSpans(
            spanDataList: pendingSpans)
        }
      let semaphore = DispatchSemaphore(value: 0)
      let request = createRequest(body: body, endpoint: endpoint)

      httpClient.send(request: request) { [weak self] result in
        switch result {
        case .success:
          self?.exporterMetrics?.addSuccess(value: pendingSpans.count)
        case let .failure(error):
          self?.exporterMetrics?.addFailed(value: pendingSpans.count)
          OpenTelemetry.instance.feedbackHandler?(error.localizedDescription)
          resultValue = .failure
        }
        semaphore.signal()
      }
      semaphore.wait()
    }
    return resultValue
  }
}
