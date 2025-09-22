// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetterAuthSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BetterAuthSwift",
            targets: ["BetterAuthSwift"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BetterAuthSwift"
        ),
        .testTarget(
            name: "BetterAuthSwiftTests",
            dependencies: ["BetterAuthSwift"]
        ),
    ]
)
