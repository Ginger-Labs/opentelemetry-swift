/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

/// Keys used by Opentelemetry to store values in the Context
public enum OpenTelemetryContextKeys: String {
  case span
  case baggage
}

public struct OpenTelemetryContextProvider {
  package var contextManager: ContextManager
}

extension OpenTelemetry {

    public static func registerDefaultContextProvider() {
        #if canImport(os.activity)
          let manager = ActivityContextManager.instance
        #elseif canImport(_Concurrency)
          let manager = TaskLocalContextManager.instance
        #else
          #error("No default ContextManager is supported on the target platform")
        #endif
        instance._contextProvider = OpenTelemetryContextProvider(contextManager: manager)
    }

    public var contextProvider: OpenTelemetryContextProvider {
        _contextProvider as! OpenTelemetryContextProvider
    }

    public mutating func registerContextManager(contextManager: ContextManager) {
      var contextProvider = self._contextProvider as! OpenTelemetryContextProvider
      contextProvider.contextManager = contextManager
    }

    /// A utility method for testing which sets the context manager for the duration of the closure, and then reverts it before the method returns
    mutating func withContextManager<T>(_ manager: ContextManager, _ operation: () throws -> T) rethrows -> T {
      var contextProvider = self._contextProvider as! OpenTelemetryContextProvider
      let old = contextProvider.contextManager
      defer {
        contextProvider.contextManager = old
      }

      contextProvider.contextManager = manager

      return try operation()
    }

}
