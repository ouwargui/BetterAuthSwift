<p align="center">
  <h2 align="center">Better Auth Swift</h2>

  <p align="center">
    Better Auth client for Swift
    <br />
    <br />
      <a href="https://ouwargui.github.io/BetterAuthSwift/documentation/betterauth/"><strong>Docs</strong></a>
    <br />
    <br />
      <a href="https://swiftpackageindex.com/ouwargui/BetterAuthSwift"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fouwargui%2FBetterAuthSwift%2Fbadge%3Ftype%3Dswift-versions"></a>
      <a href="https://swiftpackageindex.com/ouwargui/BetterAuthSwift"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fouwargui%2FBetterAuthSwift%2Fbadge%3Ftype%3Dplatforms"></a>
      <a href="https://github.com/ouwargui/BetterAuthSwift/actions/workflows/test.yaml" title="Test"><img src="https://github.com/ouwargui/BetterAuthSwift/actions/workflows/test.yaml/badge.svg"></a>
      <a href="https://github.com/ouwargui/BetterAuthSwift/actions/workflows/docs.yaml" title="Documentation"><img src="https://github.com/ouwargui/BetterAuthSwift/actions/workflows/docs.yaml/badge.svg"></a>
    <br />
  </p>
</p>

## Installation

Before starting, make sure to check the [Better Auth docs](https://www.better-auth.com/docs/) first.

### Swift Package Manager (SPM)

Add BetterAuthSwift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Select the version you want to use (always use a tag version instead of main, since main is not stable)

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(
      url: "https://github.com/ouwargui/BetterAuthSwift.git",
      .upToNextMajor(from: "1.0.0") // always use a tag version instead of main, since main is not stable
    )
]
```

## Quick Setup

### 1. Initialize the client

```swift
import BetterAuth

let client = BetterAuthClient(
  baseURL: URL(string: "https://your-api.com")!
)
```

### 2. Sign In with Email

```swift
let response = try? await client.signIn.email(with: .init(
  email: "user@example.com",
  password: "securepassword"
))
print(response.data.user.name)

// Session is a @Published variable
print(client.session?.token)

// So is user
print(client.user?.name)
```

### 3. Use in SwiftUI

```swift
import SwiftUI
import BetterAuth

@main
struct MyApp: App {
  @StateObject private var authClient = BetterAuthClient(
    baseURL: URL(string: "https://your-api.com")!
  )

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(authClient)
    }
  }
}

struct ContentView: View {
  @EnvironmentObject private var authClient: BetterAuthClient

  var body: some View {
    if let user = authClient.user {
      Text("Hello, \(user.name)")
    }

    if let session = authClient.session {
      Button {
        Task {
          try await authClient.signOut()
        }
      }
      label: {
        Text("Sign out")
      }
    } else {
      Button {
        Task {
          try await authClient.signIn.email(with: .init(email: "user@example.com", password: "securepassword"))
        }
      }
      label: {
        Text("Sign in")
      }
    }
  }
}
```

## Adding a plugin

### 1. Link the plugin to your target

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Click on **Add package**
4. Choose the plugins you want to use and add them to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(
      url: "https://github.com/ouwargui/BetterAuthSwift.git",
      .upToNextMajor(from: "1.0.0")
    )
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

### 2. Use the plugin

```swift
import BetterAuth
import BetterAuthTwoFactor

let client = BetterAuthClient(
  baseURL: URL(string: "https://your-api.com")!
)

if let user = client.user,
   let twoFactorEnabled = user.twoFactorEnabled {
      print(twoFactorEnabled) // true or false
   }
```

## Supported plugins

### Authentication

- [x] [Two Factor](https://ouwargui.github.io/BetterAuthSwift/documentation/betterauthtwofactor/)
- [x] [Username](https://ouwargui.github.io/BetterAuthSwift/documentation/betterauthusername/)
- [x] [Anonymous](https://ouwargui.github.io/BetterAuthSwift/documentation/betterauthanonymous/)
- [x] [Phone Number](https://ouwargui.github.io/BetterAuthSwift/documentation/betterauthphonenumber/)
- [ ] Magic Link
- [ ] Email OTP
- [ ] Passkey
- [ ] Generic OAuth
- [ ] One Tap
- [ ] Sign In With Ethereum

### Authorization

- [ ] Admin
- [ ] API Key
- [ ] MCP
- [ ] Organization

### Enterprise

- [ ] OIDC Provider
- [ ] SSO

### Utility

- [ ] Bearer
- [ ] Device Authorization
- [ ] New
- [ ] Captcha
- [ ] Have I Been Pwned
- [ ] Last Login Method
- [ ] Multi Session
- [ ] OAuth Proxy
- [ ] One-Time Token
- [ ] Open API
- [ ] JWT

### 3rd party

- [ ] Stripe
- [ ] Polar
- [ ] Autumn Billing
- [ ] Dodo Payments
- [ ] Dub

## More information

Visit the [Better Auth Swift docs](https://ouwargui.github.io/BetterAuthSwift/documentation/betterauth/) for more information.

## Why

Better Auth is an awesome authentication library and after struggling a bit to create bindings for every route I decided to create this package to facilitate the life of the Swift developer.

## Disclaimer

This is a community-driven project and I'm not affiliated with Better Auth in any way.
