// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Resourced",
    products: [
        .library(
            name: "Resourced",
            targets: ["Resourced"]),
    ],
    targets: [
        .target(
            name: "Resourced"),
        .testTarget(
            name: "ResourcedTests",
            dependencies: ["Resourced"]),
    ]
)
