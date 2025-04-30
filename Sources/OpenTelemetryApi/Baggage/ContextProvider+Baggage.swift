
extension OpenTelemetryContextProvider {

    /// Returns the Baggage from the current context
    public var activeBaggage: Baggage? {
      return contextManager.getCurrentContextValue(forKey: OpenTelemetryContextKeys.baggage) as? Baggage
    }

    /// Sets the span as the activeSpan for the current context
    /// - Parameter baggage: the Correlation Context to be set to the current context
    public func setActiveBaggage(_ baggage: Baggage) {
      contextManager.setCurrentContextValue(forKey: OpenTelemetryContextKeys.baggage, value: baggage)
    }
    
    public func removeContextForBaggage(_ baggage: Baggage) {
      contextManager.removeContextValue(forKey: OpenTelemetryContextKeys.baggage, value: baggage)
    }

    public func withActiveBaggage<T>(_ span: Baggage, _ operation: () throws -> T) rethrows -> T {
      try contextManager.withCurrentContextValue(forKey: .baggage, value: span, operation)
    }

    #if canImport(_Concurrency)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func withActiveBaggage<T>(_ span: Baggage, _ operation: () async throws -> T) async rethrows -> T {
      try await contextManager.withCurrentContextValue(forKey: .baggage, value: span, operation)
    }
    #endif

}
