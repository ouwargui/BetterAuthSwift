// swift-tools-version: 6.1

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
    .library(name: "BetterAuthPhoneNumber", targets: ["BetterAuthPhoneNumber"]),
    .library(name: "BetterAuthMagicLink", targets: ["BetterAuthMagicLink"])
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
      dependencies: [],
      path: "Sources/Core"
    ),
    .target(
      name: "BetterAuthTwoFactor",
      dependencies: ["BetterAuth"],
      path: "Sources/Plugins/TwoFactor"
    ),
    .target(
      name: "BetterAuthUsername",
      dependencies: ["BetterAuth"],
      path: "Sources/Plugins/Username"
    ),
    .target(
      name: "BetterAuthAnonymous",
      dependencies: ["BetterAuth"],
      path: "Sources/Plugins/Anonymous"
    ),
    .target(
      name: "BetterAuthPhoneNumber",
      dependencies: ["BetterAuth"],
      path: "Sources/Plugins/PhoneNumber"
    ),
    .target(
      name: "BetterAuthMagicLink",
      dependencies: ["BetterAuth"],
      path: "Sources/Plugins/MagicLink"
    ),
    .testTarget(
      name: "BetterAuthTests",
      dependencies: ["BetterAuth"]
    )
  ]
)
