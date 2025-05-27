Pod::Spec.new do |spec|
  spec.name = "OpenTelemetry-Swift-StdoutExporter"
  spec.version = "1.15.0"
  spec.summary = "Swift OpenTelemetry Standard output Exporter"

  spec.homepage = "https://github.com/open-telemetry/opentelemetry-swift"
  spec.documentation_url = "https://opentelemetry.io/docs/languages/swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.authors = "OpenTelemetry Authors"

  spec.source = { :git => "https://github.com/open-telemetry/opentelemetry-swift.git", :tag => spec.version.to_s }

  spec.swift_version = "5.10"
  spec.ios.deployment_target = "13.0"
  spec.tvos.deployment_target = "13.0"
  spec.watchos.deployment_target = "6.0"
  spec.module_name = "StdoutExporter"

  spec.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS" => "-module-name StdoutExporter -package-name opentelemetry_swift_stdout_exporter" }

  spec.subspec 'Logs' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Logs'
    s.dependency 'OpenTelemetry-Swift-Sdk/Logs'
    s.source_files = 'Sources/Exporters/Stdout/StdoutLogExporter.swift'
  end

  spec.subspec 'Metrics' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Metrics'
    s.dependency 'OpenTelemetry-Swift-Sdk/Metrics'
    s.source_files = 'Sources/Exporters/Stdout/StdoutMetricExporter.swift'
  end

  spec.subspec 'Trace' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Trace'
    s.dependency 'OpenTelemetry-Swift-Sdk/Trace'
    s.source_files = 'Sources/Exporters/Stdout/StdoutSpanExporter.swift'
  end

  spec.subspec 'Notability' do |s|
    s.dependency 'OpenTelemetry-Swift-StdoutExporter/Logs'
    s.dependency 'OpenTelemetry-Swift-StdoutExporter/Trace'
  end

end
