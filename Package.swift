// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BetterAuthSwift",
    platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v4), .visionOS(.v1)],
    products: [
        .library(
            name: "BetterAuth",
            targets: ["BetterAuth"]
        )
    ],
    targets: [
        .target(
            name: "BetterAuth"
        ),
        .testTarget(
            name: "BetterAuthTests",
            dependencies: ["BetterAuth"]
        )
    ]
)
