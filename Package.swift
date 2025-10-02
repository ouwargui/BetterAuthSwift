// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "BetterAuthSwift",
  platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v4), .visionOS(.v1)],
  products: [
    .library(
      name: "BetterAuth",
      targets: ["BetterAuth"]
    ),
    .library(name: "BetterAuthTwoFactor", targets: ["BetterAuthTwoFactor"]),
    .library(name: "BetterAuthUsername", targets: ["BetterAuthUsername"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/swiftlang/swift-docc-plugin",
      .upToNextMajor(from: "1.4.5")
    )
  ],
  targets: [
    .target(
      name: "BetterAuth",
      dependencies: []
    ),
    .target(
      name: "BetterAuthTwoFactor",
      dependencies: ["BetterAuth"]
    ),
    .target(
      name: "BetterAuthUsername",
      dependencies: ["BetterAuth"]
    ),
    .testTarget(
      name: "BetterAuthTests",
      dependencies: ["BetterAuth"]
    ),
  ]
)
