// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(name: "opentelemetry-swift",
                      platforms: [
                        .macOS(.v12),
                        .iOS(.v13),
                        .tvOS(.v13),
                        .watchOS(.v6)
                      ],
                      products: [
                        .library(name: "OpenTelemetryApi", targets: ["OpenTelemetryApi"]),
                        .library(name: "OpenTelemetrySdk", targets: ["OpenTelemetrySdk"]),
                        .library(name: "StdoutExporter", targets: ["StdoutExporter"]),
                        .library(name: "PersistenceExporter", targets: ["PersistenceExporter"]),
                        .library(name: "OpenTelemetryProtocolExporterHTTP", targets: ["OpenTelemetryProtocolExporterHttp"]),
                        .library(name: "DataCompression", type: .static, targets: ["DataCompression"]),
                      ],
                      dependencies: [
                        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.20.2"),
                        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.4"),
                        .package(url: "https://github.com/apple/swift-atomics.git", from: "1.2.0")
                      ],
                      targets: [
                        .target(name: "OpenTelemetryApi",
                                dependencies: []),
                        .target(name: "OpenTelemetrySdk",
                                dependencies: ["OpenTelemetryApi",
                                               .product(name: "Atomics", package: "swift-atomics", condition: .when(platforms: [.linux]))]),
                        .target(name: "OpenTelemetryTestUtils",
                                dependencies: ["OpenTelemetryApi", "OpenTelemetrySdk"]),
                        .target(name: "OpenTelemetryProtocolExporterCommon",
                                dependencies: ["OpenTelemetrySdk",
                                               .product(name: "Logging", package: "swift-log"),
                                               .product(name: "SwiftProtobuf", package: "swift-protobuf")],
                                path: "Sources/Exporters/OpenTelemetryProtocolCommon"),
                        .target(name: "OpenTelemetryProtocolExporterHttp",
                                dependencies: ["OpenTelemetrySdk",
                                               "OpenTelemetryProtocolExporterCommon",
                                               "DataCompression"],
                                path: "Sources/Exporters/OpenTelemetryProtocolHttp"),
                        .target(name: "DataCompression",
                                dependencies: [],
                                path: "Sources/Exporters/DataCompression"),
                        .target(name: "StdoutExporter",
                                dependencies: ["OpenTelemetrySdk"],
                                path: "Sources/Exporters/Stdout"),
                        .target(name: "PersistenceExporter",
                                dependencies: ["OpenTelemetrySdk"],
                                path: "Sources/Exporters/Persistence"),
                        .testTarget(name: "OpenTelemetryApiTests",
                                    dependencies: ["OpenTelemetryApi", "OpenTelemetryTestUtils"],
                                    path: "Tests/OpenTelemetryApiTests"),
                      ]).addPlatformSpecific()

extension Package {
  func addPlatformSpecific() -> Self {
    #if canImport(Darwin)
      products.append(contentsOf: [
        .library(name: "NetworkStatus", targets: ["NetworkStatus"]),
        .library(name: "URLSessionInstrumentation", targets: ["URLSessionInstrumentation"]),
        .library(name: "ZipkinExporter", targets: ["ZipkinExporter"]),
        .executable(name: "OTLPHTTPExporter", targets: ["OTLPHTTPExporter"]),
        .library(name: "SignPostIntegration", targets: ["SignPostIntegration"]),
        .library(name: "ResourceExtension", targets: ["ResourceExtension"])
      ])
      targets.append(contentsOf: [
        .target(name: "NetworkStatus",
                dependencies: [
                  "OpenTelemetryApi"
                ],
                path: "Sources/Instrumentation/NetworkStatus",
                linkerSettings: [.linkedFramework("CoreTelephony", .when(platforms: [.iOS]))]),
        .testTarget(name: "NetworkStatusTests",
                    dependencies: [
                      "NetworkStatus"
                    ],
                    path: "Tests/InstrumentationTests/NetworkStatusTests"),
        .target(name: "URLSessionInstrumentation",
                dependencies: ["OpenTelemetrySdk", "NetworkStatus"],
                path: "Sources/Instrumentation/URLSession",
                exclude: ["README.md"]),
        .executableTarget(name: "NetworkSample",
                          dependencies: ["URLSessionInstrumentation", "StdoutExporter"],
                          path: "Examples/Network Sample",
                          exclude: ["README.md"]),
        .target(name: "ZipkinExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Zipkin"),
        .testTarget(name: "ZipkinExporterTests",
                    dependencies: ["ZipkinExporter"],
                    path: "Tests/ExportersTests/Zipkin"),
        .executableTarget(name: "OTLPHTTPExporter",
                          dependencies: ["OpenTelemetrySdk", "OpenTelemetryProtocolExporterHttp", "StdoutExporter", "ZipkinExporter", "ResourceExtension", "SignPostIntegration", "DataCompression"],
                          path: "Examples/OTLP HTTP Exporter",
                          exclude: ["README.md"]),
        .target(name: "SignPostIntegration",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Instrumentation/SignPostIntegration",
                exclude: ["README.md"]),
        .target(name: "ResourceExtension",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Instrumentation/SDKResourceExtension",
                exclude: ["README.md"]),
        .testTarget(name: "ResourceExtensionTests",
                    dependencies: ["ResourceExtension", "OpenTelemetrySdk"],
                    path: "Tests/InstrumentationTests/SDKResourceExtensionTests"),
      ])
    #endif

    return self
  }
}

if ProcessInfo.processInfo.environment["OTEL_ENABLE_SWIFTLINT"] != nil {
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.1")
  ])

  for target in package.targets {
    target.plugins = [
      .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
    ]
  }
}
