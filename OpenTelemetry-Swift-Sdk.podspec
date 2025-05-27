Pod::Spec.new do |spec|
  spec.name = "OpenTelemetry-Swift-Sdk"
  spec.version = "1.15.0"
  spec.summary = "Swift OpenTelemetrySDK"

  spec.homepage = "https://github.com/open-telemetry/opentelemetry-swift"
  spec.documentation_url = "https://opentelemetry.io/docs/languages/swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.authors = "OpenTelemetry Authors"

  spec.source = { :git => "https://github.com/open-telemetry/opentelemetry-swift.git", :tag => spec.version.to_s }

  spec.swift_version = "5.10"
  spec.ios.deployment_target = "13.0"
  spec.tvos.deployment_target = "13.0"
  spec.watchos.deployment_target = "6.0"
  spec.module_name = "OpenTelemetrySdk"

  spec.subspec 'Core' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Core'
    s.source_files = ['Sources/OpenTelemetrySdk/*.swift', 'Sources/OpenTelemetrySdk/Common/**/*.swift', 'Sources/OpenTelemetrySdk/Internal/**/*.swift', 'Sources/OpenTelemetrySdk/Resources/**/*.swift']
  end

  spec.subspec 'Logs' do |s|
    s.dependency 'OpenTelemetry-Swift-Sdk/Core'
    s.source_files = 'Sources/OpenTelemetrySdk/Logs/**/*.swift'
  end

  spec.subspec 'Metrics' do |s|
    s.dependency 'OpenTelemetry-Swift-Sdk/Core'
    s.source_files = 'Sources/OpenTelemetrySdk/Metrics/**/*.swift'
  end

  spec.subspec 'Trace' do |s|
    s.dependency 'OpenTelemetry-Swift-Sdk/Core'
    s.source_files = 'Sources/OpenTelemetrySdk/Trace/**/*.swift'
  end

  spec.subspec 'TraceMetrics' do |s|
    s.dependency 'OpenTelemetry-Swift-Sdk/Trace'
    s.dependency 'OpenTelemetry-Swift-Sdk/Metrics'
    s.source_files = 'Sources/OpenTelemetrySdk/TraceMetrics/**/*.swift'
  end

  spec.subspec 'Notability' do |s|
    s.dependency 'OpenTelemetry-Swift-Sdk/Logs'
    s.dependency 'OpenTelemetry-Swift-Sdk/Trace'
  end

end
