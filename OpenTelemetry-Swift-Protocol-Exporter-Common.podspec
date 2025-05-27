Pod::Spec.new do |spec|
  spec.name = "OpenTelemetry-Swift-Protocol-Exporter-Common"
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
  spec.module_name = "OpenTelemetryProtocolExporterCommon"

  spec.dependency 'SwiftProtobuf', '~> 1.28'
  spec.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS" => "-module-name OpenTelemetryProtocolExporterCommon -package-name opentelemetry_swift_exporter_common" }

  spec.subspec 'Core' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Core'
    s.dependency 'OpenTelemetry-Swift-Sdk/Core'
    s.source_files = ['Sources/Exporters/OpenTelemetryProtocolCommon/common/*.swift', 'Sources/Exporters/OpenTelemetryProtocolCommon/proto/*.swift']
  end

  spec.subspec 'Logs' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Logs'
    s.dependency 'OpenTelemetry-Swift-Sdk/Logs'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolCommon/logs/*.swift'
  end

  spec.subspec 'Metrics' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Metrics'
    s.dependency 'OpenTelemetry-Swift-Sdk/Metrics'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolCommon/metric/*.swift'
  end

  spec.subspec 'Trace' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Trace'
    s.dependency 'OpenTelemetry-Swift-Sdk/Trace'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Core'
    s.source_files = 'Sources/Exporters/OpenTelemetryProtocolCommon/trace/**/*.swift'
  end

  spec.subspec 'ExporterMetrics' do |s|
      s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Metrics'
      s.source_files = 'Sources/Exporters/OpenTelemetryProtocolCommon/exportermetrics/*.swift'
  end

  spec.subspec 'Notability' do |s|
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Logs'
    s.dependency 'OpenTelemetry-Swift-Protocol-Exporter-Common/Trace'
  end

end
