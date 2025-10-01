<p align="center">
  <h2 align="center">Better Auth Swift</h2>

  <p align="center">
    Better Auth client for Swift
    <br />
    <br />
      <a href="https://ouwargui.github.io/BetterAuthSwift/documentation/betterauth/"><strong>Docs</strong></a>
  </p>
</p>

## Installation

Before starting, make sure to check the [Better Auth docs](https://www.better-auth.com/docs/) first.

### Swift Package Manager (SPM)

Add BetterAuthSwift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(
      url: "https://github.com/ouwargui/BetterAuthSwift.git",
      .upToNextMajor(from: "0.3.0")
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
print(response.user.name)

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
```

## Supported plugins

### Authentication

- [x] Two Factor
- [ ] Username
- [ ] Anonymous
- [ ] Phone Number
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
