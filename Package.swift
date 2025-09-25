// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "BetterAuthSwift",
    platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v4), .visionOS(.v1)],
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
