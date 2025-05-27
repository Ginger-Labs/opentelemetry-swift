
extension OpenTelemetryContextProvider {

    /// Returns the Span from the current context
    public var activeSpan: Span? {
        return contextManager.getCurrentContextValue(forKey: .span) as? Span
    }

    /// Sets the span as the activeSpan for the current context
    /// - Parameter span: the Span to be set to the current context
    public func setActiveSpan(_ span: Span) {
        contextManager.setCurrentContextValue(forKey: OpenTelemetryContextKeys.span, value: span)
    }

    public func removeContextForSpan(_ span: Span) {
        contextManager.removeContextValue(forKey: OpenTelemetryContextKeys.span, value: span)
    }

    /// Sets `span` as the active span for the duration of the given closure.
    /// While the span will no longer be active after the closure exits, this method does **not** end the span.
    /// Prefer `SpanBuilderBase.withActiveSpan` which handles starting, activating, and ending the span.
    public func withActiveSpan<T>(_ span: SpanBase, _ operation: () throws -> T) rethrows -> T {
        try contextManager.withCurrentContextValue(forKey: .span, value: span, operation)
    }

#if canImport(_Concurrency)
    /// Sets `span` as the active span for the duration of the given closure.
    /// While the span will no longer be active after the closure exits, this method does **not** end the span.
    /// Prefer `SpanBuilderBase.withActiveSpan` which handles starting, activating, and ending the span.
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func withActiveSpan<T>(_ span: SpanBase, _ operation: () async throws -> T) async rethrows -> T {
        try await contextManager.withCurrentContextValue(forKey: .span, value: span, operation)
    }
#endif

}
