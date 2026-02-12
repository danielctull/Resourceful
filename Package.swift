// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "Resourceful",
  platforms: [
    .iOS(.v13),
    .macOS(.v11),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Resourceful", targets: ["Resourceful"])
  ],
  targets: [

    .target(
      name: "Resourceful"
    ),

    .testTarget(
      name: "ResourcefulTests",
      dependencies: [
        "Resourceful"
      ],
      resources: [
        .process("Resources"),
      ]
    ),
  ]
)
