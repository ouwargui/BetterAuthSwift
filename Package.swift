// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "BetterAuthSwift",
  platforms: [.macOS(.v11), .iOS(.v14), .visionOS(.v1)],
  products: [
    .library(
      name: "BetterAuth",
      targets: ["BetterAuth"]
    ),
    .library(name: "BetterAuthTwoFactor", targets: ["BetterAuthTwoFactor"]),
    .library(name: "BetterAuthUsername", targets: ["BetterAuthUsername"]),
    .library(name: "BetterAuthAnonymous", targets: ["BetterAuthAnonymous"]),
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
    .target(
      name: "BetterAuthAnonymous",
      dependencies: ["BetterAuth"]
    ),
    .testTarget(
      name: "BetterAuthTests",
      dependencies: ["BetterAuth"]
    ),
  ]
)
