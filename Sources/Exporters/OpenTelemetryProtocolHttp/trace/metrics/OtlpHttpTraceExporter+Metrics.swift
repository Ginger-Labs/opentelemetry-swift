import Foundation
import OpenTelemetryApi
import OpenTelemetryProtocolExporterCommon

extension OtlpHttpTraceExporter {

    /// A `convenience` constructor to provide support for exporter metric using`StableMeterProvider` type
    /// - Parameters:
    ///    - endpoint: Exporter endpoint injected as dependency
    ///    - config: Exporter configuration including type of exporter
    ///    - meterProvider: Injected `StableMeterProvider` for metric
    ///    - useSession: Overridden `URLSession` if any
    ///    - envVarHeaders: Extra header key-values
    public convenience init(endpoint: URL,
                            config: OtlpConfiguration,
                            meterProvider: StableMeterProvider,
                            useSession: URLSession? = nil,
                            envVarHeaders: [(String, String)]? = EnvVarHeaders.attributes) {
      self.init(endpoint: endpoint, config: config, useSession: useSession,
                envVarHeaders: envVarHeaders)
      exporterMetrics = ExporterMetrics(type: "span",
                                        meterProvider: meterProvider,
                                        exporterName: "otlp",
                                        transportName: config.exportAsJson
                                          ? ExporterMetrics.TransporterType.httpJson
                                          : ExporterMetrics.TransporterType.grpc)
    }

}
