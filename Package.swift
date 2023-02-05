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
            name: "Resourceful",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
            ]
        ),

        .testTarget(
            name: "ResourcefulTests",
            dependencies: ["Resourceful"]),
    ]
)
