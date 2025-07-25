//
// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public class MultiLogRecordExporter: LogRecordExporter {
  var logRecordExporters: [LogRecordExporter]

  public init(logRecordExporters: [LogRecordExporter]) {
    self.logRecordExporters = logRecordExporters
  }

  public func export(logRecords: [ReadableLogRecord], explicitTimeout: TimeInterval?, completion: ((ExportResult) -> Void)?) {
      Task {
          var result = ExportResult.success
          await withTaskGroup { group in
              logRecordExporters.forEach { exporter in
                  group.addTask {
                      let newResult = await withCheckedContinuation { continuation in
                          exporter.export(logRecords: logRecords, explicitTimeout: explicitTimeout) { result in
                              continuation.resume(returning: result)
                          }
                      }
                      result.mergeResultCode(newResultCode: newResult)
                  }
              }
          }
          completion?(result)
      }
  }

  public func shutdown(explicitTimeout: TimeInterval? = nil) {
    logRecordExporters.forEach {
      $0.shutdown(explicitTimeout: explicitTimeout)
    }
  }

  public func forceFlush(explicitTimeout: TimeInterval? = nil) -> ExportResult {
    var result = ExportResult.success
    logRecordExporters.forEach {
      result.mergeResultCode(newResultCode: $0.forceFlush(explicitTimeout: explicitTimeout))
    }
    return result
  }
}
