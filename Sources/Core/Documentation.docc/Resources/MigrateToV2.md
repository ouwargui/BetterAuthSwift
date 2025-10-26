# Migrate to v2

Some changes were made to the Core API to better support future plugins, make sure users know what requests are being made by the library and to comply with new changes from the better-auth server.

## Client initialization

The ``BetterAuthClient`` now accepts a new `scheme` parameter which is required so the package can set the `origin` on HTTP requests to the server. Check the [Apple Docs](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app) to understand where to get it.

```swift
let client = BetterAuthClient(
  baseURL: "https://your-server-url.com",
  // This new parameter is required
  scheme: "your-app-scheme://",
  plugins: [
    TwoFactorPlugin(), UsernamePlugin(), PhoneNumberPlugin(),
    MagicLinkPlugin(), EmailOTPPlugin(), PasskeyPlugin(),
  ],
)
```

## Published variables

The client provides `@Published` properties that react to some of the calls to refetch it's data if necessary. The idea is to be as similar as possible to hooks of the JS API. Because of this some changes were made to the V1 API:

### client.session and client.user are now client.session

This allows the client to also provide the async state of the variable

```swift
let client = BetterAuthClient(...)

// client.session is @Published
client.session.data.session // Session?
client.session.data.user // User?

client.session.isPending // Bool
client.session.error // BetterAuthError?
```

### Published variables don't automatically initialize their value

Since there's no `hooks` in Swift, we can't know if a `hook` is mounted or not. In V1 `@Published` variables initial values were being loaded on the client initialization, which wasn't clear and an anti-pattern.

Now if you want a initial value, you should explicitly load it:

```swift
struct MyView: View {
  @StateObject private var client = BetterAuthClient(...)

  var body: some View {
    VStack {
      ...
    }
    .task {
      // This will fetch the session if it's `nil`
      await self.client.session.refreshSessionIfNeeded()
    }
  }
}
```

A similar pattern can be found for other `@Published` variables such as the Passkey property `userPasskeys`:

```swift
struct MyView: View {
  @StateObject private var client = BetterAuthClient(...)

  var body: some View {
    VStack {
      ...
    }
    .task {
      // This will fetch the user passkeys if it's `nil`
      await self.client.passkey.userPasskeys.refreshSessionIfNeeded()
    }
  }
}
```

## Error structs

If you were using this package custom errors, like `BetterAuthSwiftError` and `BetterAuthError` you should read these changes and change your code:

### BetterAuthError is now BetterAuthApiError

``BetterAuthError`` is now a new enum created to generalize thrown errors. See changes [here](https://github.com/ouwargui/BetterAuthSwift/pull/7/files#diff-00490b97232b5ebf7228c7dbb56bb18abac65df87ec4d5177f292d4cfe011d9f).

## MiddlewareActions

MiddlewareActions was renamed to ``MiddlewareAction``. Because of this the ``HTTPClientProtocol`` changed API.

## HTTPClientProtocol

The ``HTTPClientProtocol`` now uses ``MiddlewareAction`` and the init accepts a ``PluginRegistry`` instead of an array of plugins.

## AuthPlugin Protocol

AuthPlugin protocol was renamed to ``Middleware``.

## PluginRegistry and PluginFactory

The client now uses a ``PluginRegistry`` to maintain reference to plugin instances. These instances are created through ``PluginFactory``.

Plugins classes needs to conform to ``Pluggable`` and their respective `PluginNamePlugin()` class needs to conform to ``PluginFactory``.
