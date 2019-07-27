// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Resourceful",
    products: [
        .library(
            name: "Resourceful",
            targets: ["Resourceful"]),
    ],
    targets: [
        .target(
            name: "Resourceful"),
        .testTarget(
            name: "ResourcefulTests",
            dependencies: ["Resourceful"]),
    ]
)
