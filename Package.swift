// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "HTTP",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "HTTP",
            targets: ["HTTP"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-http-types",
            from: "1.4.0"
        )
    ],
    targets: [
        .target(
            name: "HTTP",
            dependencies: [
                .product(
                    name: "HTTPTypes",
                    package: "swift-http-types"
                ),
                .product(
                    name: "HTTPTypesFoundation",
                    package: "swift-http-types"
                )
            ]
        ),
        .testTarget(
            name: "HTTPTests",
            dependencies: ["HTTP"]
        ),
    ]
)
