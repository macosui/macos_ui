// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "macos_ui",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "macos-ui", targets: ["macos_ui"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "macos_ui",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        )
    ]
)