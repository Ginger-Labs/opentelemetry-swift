Pod::Spec.new do |spec|
  spec.name = "OpenTelemetry-Swift-Protocol-Exporter-Http"
  spec.version = "1.15.0"
  spec.summary = "Swift OpenTelemetry Protocol Exporter Common"

  spec.homepage = "https://github.com/open-telemetry/opentelemetry-swift"
  spec.documentation_url = "https://opentelemetry.io/docs/languages/swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.authors = "OpenTelemetry Authors"

  spec.source = { :git => "https://github.com/open-telemetry/opentelemetry-swift.git", :tag => spec.version.to_s }

  spec.swift_version = "5.10"
  spec.ios.deployment_target = "13.0"
  spec.tvos.deployment_target = "13.0"
  spec.watchos.deployment_target = "6.0"
  spec.module_name = "OpenTelemetryProtocolExporterHttp"

  spec.dependency 'OpenTelemetry-Swift-DataCompression', spec.version.to_s
  spec.dependency 'SwiftProtobuf', '~> 1.28'
  spec.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS" => "-module-name OpenTelemetryProtocolExporterHttp -package-name opentelemetry_swift_exporter_http" }

  spec.subspec 'Core' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Core'
    s.dependency 'OpenTelemetry-Swift-Sdk/Core'
    spec.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolHttp/*.swift'
  end

  spec.subspec 'Metrics' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Metrics'
    s.dependency 'OpenTelemetry-Swift-Sdk/Metrics'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Http/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolHttp/metric/*.swift'

    s.subspec 'ExporterMetrics' do |sub|
      sub.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/ExporterMetrics'
      sub.source_files = ['Sources/Exporters/OpenTelemetryProtocolHttp/metric/metrics/*.swift', 'Sources/Exporters/OpenTelemetryProtocolHttp/logs/metrics/*.swift', 'Sources/Exporters/OpenTelemetryProtocolHttp/trace/metrics/*.swift']
    end
  end

  spec.subspec 'Logs' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Logs'
    s.dependency 'OpenTelemetry-Swift-Sdk/Logs'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Http/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolHttp/logs/*.swift'
  end

  spec.subspec 'Trace' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Trace'
    s.dependency 'OpenTelemetry-Swift-Sdk/Trace'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Http/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolHttp/trace/*.swift'
  end

  spec.subspec 'Notability' do |s|
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Http/Logs'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Http/Trace'
  end

end
