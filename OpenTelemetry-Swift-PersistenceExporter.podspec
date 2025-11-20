Pod::Spec.new do |spec|
  spec.name = "OpenTelemetry-Swift-PersistenceExporter"
  spec.version = "1.15.0"
  spec.summary = "Swift OpenTelemetry Persistence Exporter"

  spec.homepage = "https://github.com/open-telemetry/opentelemetry-swift"
  spec.documentation_url = "https://opentelemetry.io/docs/languages/swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.authors = "OpenTelemetry Authors"

  spec.source = { :git => "https://github.com/open-telemetry/opentelemetry-swift.git", :tag => spec.version.to_s }

  spec.swift_version = "5.10"
  spec.ios.deployment_target = "13.0"
  spec.tvos.deployment_target = "13.0"
  spec.watchos.deployment_target = "6.0"
  spec.module_name = "PersistenceExporter"

  spec.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS" => "-module-name PersistenceExporter -package-name opentelemetry_swift_persistence_exporter" }

  spec.subspec 'Core' do |s|
    s.source_files = ['Sources/Exporters/Persistence/PersistenceExporterDecorator.swift',
                      'Sources/Exporters/Persistence/PersistencePerformancePreset.swift',
                      'Sources/Exporters/Persistence/Export/*.swift',
                      'Sources/Exporters/Persistence/Storage/*.swift',
                      'Sources/Exporters/Persistence/Utils/*.swift']
  end

  spec.subspec 'Logs' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Logs'
    s.dependency 'OpenTelemetry-Swift-Sdk/Logs'
    s.dependency 'OpenTelemetry-Swift-PersistenceExporter/Core'
    s.source_files = 'Sources/Exporters/Persistence/PersistenceLogExporterDecorator.swift'
  end

  spec.subspec 'Metrics' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Metrics'
    s.dependency 'OpenTelemetry-Swift-Sdk/Metrics'
    s.dependency 'OpenTelemetry-Swift-PersistenceExporter/Core'
    s.source_files = 'Sources/Exporters/Persistence/PersistenceMetricExporterDecorator.swift'
  end

  spec.subspec 'Trace' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Trace'
    s.dependency 'OpenTelemetry-Swift-Sdk/Trace'
    s.dependency 'OpenTelemetry-Swift-PersistenceExporter/Core'
    s.source_files = 'Sources/Exporters/Persistence/PersistenceSpanExporterDecorator.swift'
  end

  spec.subspec 'Notability' do |s|
    s.dependency 'OpenTelemetry-Swift-PersistenceExporter/Logs'
    s.dependency 'OpenTelemetry-Swift-PersistenceExporter/Trace'
  end

end
