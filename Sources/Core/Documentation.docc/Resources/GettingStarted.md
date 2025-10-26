# Getting Started

Learn how to integrate Better Auth Swift into your project.

## Installation

### Swift Package Manager (SPM)

Add Better Auth Swift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/ouwargui/BetterAuthSwift.git`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ouwargui/BetterAuthSwift.git", from: "2.0.0")
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

// Will be automatically updated
print(client.session.data?.session)

// So will the user
print(client.session.data?.user)
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
        .task {
          // Explicitly fetch the initial session.
          // future changes to the session will
          // be automatically updated
          await authClient.session.refreshSession()
        }
    }
  }
}
```
