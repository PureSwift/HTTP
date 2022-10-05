// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
            url: "https://github.com/PureSwift/Socket.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "HTTP",
            dependencies: [
                "Socket",
                .product(
                    name: "Algorithms",
                    package: "swift-algorithms"
                )
            ]
        ),
        .testTarget(
            name: "HTTPTests",
            dependencies: ["HTTP"]
        ),
    ]
)
