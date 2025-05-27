import Foundation
import OpenTelemetryApi
import OpenTelemetryProtocolExporterCommon
import OpenTelemetrySdk

extension OtlpHttpMetricExporter {

    /// A `convenience` constructor to provide support for exporter metric using`StableMeterProvider` type
    /// - Parameters:
    ///    - endpoint: Exporter endpoint injected as dependency
    ///    - config: Exporter configuration including type of exporter
    ///    - meterProvider: Injected `StableMeterProvider` for metric
    ///    - useSession: Overridden `URLSession` if any
    ///    - envVarHeaders: Extra header key-values
    public convenience init(endpoint: URL = defaultOltpHTTPMetricsEndpoint(),
                            config: OtlpConfiguration = OtlpConfiguration(),
                            meterProvider: StableMeterProvider,
                            useSession: URLSession? = nil,
                            envVarHeaders: [(String, String)]? = EnvVarHeaders.attributes) {
      self.init(endpoint: endpoint, config: config, useSession: useSession,
                envVarHeaders: envVarHeaders)
      exporterMetrics = ExporterMetrics(type: "metric",
                                        meterProvider: meterProvider,
                                        exporterName: "otlp",
                                        transportName: config.exportAsJson
                                          ? ExporterMetrics.TransporterType.httpJson
                                          : ExporterMetrics.TransporterType.grpc)
    }

}

extension StableOtlpHTTPMetricExporter {

    /// A `convenience` constructor to provide support for exporter metric using`StableMeterProvider` type
    /// - Parameters:
    ///    - endpoint: Exporter endpoint injected as dependency
    ///    - config: Exporter configuration including type of exporter
    ///    - meterProvider: Injected `StableMeterProvider` for metric
    ///    - aggregationTemporalitySelector: aggregator
    ///    - defaultAggregationSelector: default aggregator
    ///    - useSession: Overridden `URLSession` if any
    ///    - envVarHeaders: Extra header key-values
    public convenience init(endpoint: URL,
                            config: OtlpConfiguration = OtlpConfiguration(),
                            meterProvider: StableMeterProvider,
                            aggregationTemporalitySelector: AggregationTemporalitySelector =
                              AggregationTemporality.alwaysCumulative(),
                            defaultAggregationSelector: DefaultAggregationSelector = AggregationSelector
                              .instance,
                            useSession: URLSession? = nil,
                            envVarHeaders: [(String, String)]? = EnvVarHeaders.attributes) {
      self.init(endpoint: endpoint,
                config: config,
                aggregationTemporalitySelector: aggregationTemporalitySelector,
                defaultAggregationSelector: defaultAggregationSelector,
                useSession: useSession,
                envVarHeaders: envVarHeaders)
      exporterMetrics = ExporterMetrics(type: "metric",
                                        meterProvider: meterProvider,
                                        exporterName: "otlp",
                                        transportName: config.exportAsJson
                                          ? ExporterMetrics.TransporterType.httpJson
                                          : ExporterMetrics.TransporterType.grpc)
    }

}
