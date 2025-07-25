/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetrySdk

// a persistence exporter decorator for `SpanData`.
// specialization of `PersistenceExporterDecorator` for `SpanExporter`.
public class PersistenceSpanExporterDecorator: SpanExporter {
  struct SpanDecoratedExporter: DecoratedExporter {
    typealias SignalType = SpanData

    private let spanExporter: SpanExporter

    init(spanExporter: SpanExporter) {
      self.spanExporter = spanExporter
    }

    func export(values: [SpanData], completion: @escaping (DataExportStatus) -> Void) {
      spanExporter.export(spans: values) { _ in
        completion(DataExportStatus(needsRetry: false))
      }
    }
  }

  private let spanExporter: SpanExporter
  private let persistenceExporter:
    PersistenceExporterDecorator<SpanDecoratedExporter>

  public init(spanExporter: SpanExporter,
              storageURL: URL,
              exportCondition: @escaping () -> Bool = { true },
              performancePreset: PersistencePerformancePreset = .default) throws {
    self.spanExporter = spanExporter

    persistenceExporter =
      PersistenceExporterDecorator<SpanDecoratedExporter>(decoratedExporter: SpanDecoratedExporter(spanExporter: spanExporter),
                                                          storageURL: storageURL,
                                                          exportCondition: exportCondition,
                                                          performancePreset: performancePreset)
  }

  public func export(spans: [SpanData], explicitTimeout: TimeInterval?, completion: ((OpenTelemetrySdk.SpanExporterResultCode) -> Void)?) {
    do {
      try persistenceExporter.export(values: spans)

      completion?(.success)
    } catch {
      completion?(.failure)
    }
  }

  public func flush(explicitTimeout: TimeInterval?) -> SpanExporterResultCode {
    persistenceExporter.flush()
    return spanExporter.flush(explicitTimeout: explicitTimeout)
  }

  public func shutdown(explicitTimeout: TimeInterval?) {
    persistenceExporter.flush()
    spanExporter.shutdown(explicitTimeout: explicitTimeout)
  }
}
