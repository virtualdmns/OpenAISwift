// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenAISwift",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "OpenAISwift",
            targets: ["OpenAISwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "OpenAISwift",
            dependencies: []),
        .testTarget(
            name: "OpenAISwiftTests",
            dependencies: ["OpenAISwift"]),
    ]
)