# Getting Started

Learn how to integrate BetterAuthSwift into your project.

## Installation

### Swift Package Manager (SPM)

Add BetterAuthSwift to your project using Xcode:

1. In Xcode, select **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/yourusername/BetterAuthSwift.git`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ouwargui/BetterAuthSwift.git", from: "1.0.0")
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
