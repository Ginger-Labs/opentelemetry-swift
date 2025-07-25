/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

public protocol LogRecordExporter {
  func export(logRecords: [ReadableLogRecord], explicitTimeout: TimeInterval?, completion: ((ExportResult) -> Void)?)

  /// Shutdown the log exporter
  ///
  func shutdown(explicitTimeout: TimeInterval?)

  /// Processes all the log records that have not yet been processed
  ///
  func forceFlush(explicitTimeout: TimeInterval?) -> ExportResult
}

public extension LogRecordExporter {
  func export(logRecords: [ReadableLogRecord], completion: ((ExportResult) -> Void)?) {
    return export(logRecords: logRecords, explicitTimeout: nil, completion: completion)
  }

  func shutdown() {
    shutdown(explicitTimeout: nil)
  }

  func forceFlush() -> ExportResult {
    return forceFlush(explicitTimeout: nil)
  }
}
