/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

#if canImport(os.log)
  import os.log
#endif

/// This class provides a static global accessor for telemetry objects Tracer, Meter
///  and BaggageManager.
///  The telemetry objects are lazy-loaded singletons resolved via ServiceLoader mechanism.
public struct OpenTelemetry {
  public static var version = "v1.21.0"

  public static var instance = OpenTelemetry()

  /// Registered tracerProvider or default via DefaultTracerProvider.instance.
  var _tracerProvider: Any?

  /// Registered MeterProvider or default via DefaultMeterProvider.instance.
  var _meterProvider: Any?

  var _stableMeterProvider: Any?

  /// Registered LoggerProvider or default via DefaultLoggerProvider.instance.
  var _loggerProvider: Any?

  /// registered manager or default via  DefaultBaggageManager.instance.
  var _baggageManager: Any?

  /// registered manager or default
  var _propagators: Any?

  /// registered manager or default
  var _contextProvider: Any?

  /// Allow customizing how warnings and informative messages about usages of OpenTelemetry are relayed back to the developer.
  public private(set) var feedbackHandler: ((String) -> Void)?

  private init() {
    #if canImport(os.log)
      feedbackHandler = { message in
        os_log("%{public}s", message)
      }
    #endif
  }

  /// Register a function to be called when the library has warnings or informative messages to relay back to the developer
  public static func registerFeedbackHandler(
    _ handler: @escaping (String) -> Void
  ) {
    instance.feedbackHandler = handler
  }
}
