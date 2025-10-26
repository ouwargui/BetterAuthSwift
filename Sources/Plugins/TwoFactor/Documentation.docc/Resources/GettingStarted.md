# Getting Started

Learn how to integrate the Two Factor plugin.

## Installation

### Swift Package Manager (SPM)

Add Better Auth Swift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Click on **Add package**
4. Choose the TwoFactor plugin

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ouwargui/BetterAuthSwift.git", from: "2.0.0")
],
targets: [
    .target(
      name: "MyApp",
      dependencies: [
        .product(name: "BetterAuth", package: "BetterAuthSwift"),
        .product(name: "BetterAuthTwoFactor", package: "BetterAuthSwift"),
      ]
    )
]
```

## Quick Setup

```swift
import BetterAuth

// Import the plugin
import BetterAuthTwoFactor

let client = BetterAuthClient(
  baseURL: URL(string: "https://your-api.com")!,
  scheme: "your-app-scheme://",
  plugins: [TwoFactorPlugin()]
)
```

Check the <doc:LoginWith2FA> article to learn how to sign in an user with 2FA enabled.
