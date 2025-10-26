# Getting Started

Learn how to integrate the Magic Link plugin.

## Installation

### Swift Package Manager (SPM)

Add Better Auth Swift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Click on **Add package**
4. Choose the MagicLink plugin

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
        .product(name: "BetterAuthMagicLink", package: "BetterAuthSwift"),
      ]
    )
]
```

## Quick Setup

```swift
import BetterAuth

// Import the plugin
import BetterAuthMagicLink

let client = BetterAuthClient(
  baseURL: URL(string: "https://your-api.com")!,
  scheme: "your-app-scheme://",
  plugins: [MagicLinkPlugin()]
)
```

> Tip: Check the [Better Auth docs for the Magic Link plugin](https://www.better-auth.com/docs/plugins/magic-link)
