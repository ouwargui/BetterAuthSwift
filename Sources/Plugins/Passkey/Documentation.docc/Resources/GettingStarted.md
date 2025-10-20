# Getting Started

Learn how to integrate the Passkey plugin.

## Installation

### Swift Package Manager (SPM)

Add Better Auth Swift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Click on **Add package**
4. Choose the Passkey plugin

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ouwargui/BetterAuthSwift.git", from: "1.0.0")
],
targets: [
    .target(
      name: "MyApp",
      dependencies: [
        .product(name: "BetterAuth", package: "BetterAuthSwift"),
        .product(name: "BetterAuthPasskey", package: "BetterAuthSwift"),
      ]
    )
]
```

## Setup your server

Make sure to setup support for associated domains, otherwise Passkeys won't work with your app. You can check how to do it here: [Supporting Associated Domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains)

## Quick Setup

```swift
import BetterAuth

// Import the plugin
import BetterAuthPasskey

let client = BetterAuthClient(
  baseURL: URL(string: "https://your-api.com")!,
  plugins: [PasskeyPlugin()]
)
```

Similar to the `session` variable from the ``/BetterAuth/BetterAuthClient``, you need to explicitly
fetch the initial `userPasskeys`. Future changes to the `userPasskeys` will update the variable
automatically:

```swift
import SwiftUI
import BetterAuth
import BetterAuthPasskey

@main
struct MyApp: App {
  @StateObject private var authClient = BetterAuthClient(
    baseURL: URL(string: "https://your-api.com")!,
    plugins: [PasskeyPlugin()]
  )

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(authClient)
        .task {
          // Explicitly fetch the initial value.
          // 
          // You don't necessarily need to do this on your root view.
          // In fact, it's probably better to load it when you actually need to.
          await authClient.passkey.userPasskeys.refreshPasskeys()
        }
    }
  }
}
```

Check the <doc:PasskeyAutoFill> article to learn how to use autofill with a Passkey.
