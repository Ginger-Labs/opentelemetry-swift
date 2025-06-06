Pod::Spec.new do |spec|
  spec.name = "OpenTelemetry-Swift-SdkResourceExtension"
  spec.version = "1.15.0"
  spec.summary = "Swift OpenTelemetry Resource Extension"

  spec.homepage = "https://github.com/open-telemetry/opentelemetry-swift"
  spec.documentation_url = "https://opentelemetry.io/docs/languages/swift"
  spec.license = { :type => "Apache 2.0", :file => "LICENSE" }
  spec.authors = "OpenTelemetry Authors"

  spec.source = { :git => "https://github.com/open-telemetry/opentelemetry-swift.git", :tag => spec.version.to_s }

  spec.swift_version = "5.10"
  spec.ios.deployment_target = "13.0"
  spec.tvos.deployment_target = "13.0"
  spec.watchos.deployment_target = "6.0"
  spec.module_name = "ResourceExtension"

  spec.subspec 'NetworkStatus' do |s|
    s.source_files = 'Sources/Instrumentation/NetworkStatus/**/*.swift'
  end

  spec.subspec 'SDKResourceExtension' do |s|
    s.source_files = 'Sources/Instrumentation/SDKResourceExtension/**/*.swift'
  end

  spec.subspec 'SignPostIntegration' do |s|
    s.source_files = 'Sources/Instrumentation/SignPostIntegration/**/*.swift'
  end

  spec.subspec 'URLSession' do |s|
    s.dependency 'OpenTelemetry-Swift-Api/Propagation'
    s.dependency 'OpenTelemetry-Swift-SdkResourceExtension/NetworkStatus'
    s.source_files = 'Sources/Instrumentation/URLSession/**/*.swift'
  end

  spec.subspec 'Notability' do |s|
    s.dependency 'OpenTelemetry-Swift-SdkResourceExtension/SDKResourceExtension'
    s.dependency 'OpenTelemetry-Swift-SdkResourceExtension/SignPostIntegration'
    s.dependency 'OpenTelemetry-Swift-SdkResourceExtension/URLSession'
  end

  spec.dependency 'OpenTelemetry-Swift-Api/Core', spec.version.to_s
  spec.dependency 'OpenTelemetry-Swift-Sdk/Core', spec.version.to_s
  spec.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS" => "-module-name ResourceExtension -package-name opentelemetry_swift_resource_extension" }

end
