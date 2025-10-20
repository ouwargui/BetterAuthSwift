# Passkey Autofill

The plugin supports Passkey autofill, which allows the system to suggest Passkeys when the user opens the keyboard on specific text fields.

## Supporting autofill

The user needs to have a Passkey registered for your application on his device.

That means the user needs to have added a Passkey to your application at some point and the Passkey's still exists on his device.

> Tip: Don't worry about manually checking this, you can still call the function and if there's no passkey available the call will silently fail.

Here's an example:

```swift
import BetterAuth
import BetterAuthPasskey
import SwiftUI

struct PasskeyView: View {
  @StateObject private var client = BetterAuthClient(
    // Make sure to publicly expose your server, you can use
    // ngrok if you're on localhost
    baseURL: URL(string: "https://xxxxxxxx.ngrok-free.app")!,

    // Don't forget to add the Passkey plugin to the plugins array
    plugins: [PasskeyPlugin()],
  )

  @State private var email: String = ""
  @FocusState private var emailFocused: Bool

  var body: some View {

    TextField("Email", text: $email)
      // Set the content type to `.username`
      .textContentType(.username)
      .focused($emailFocused)

      // When the user focus on the TextField, call `passkeyAutoFill()`
      .onChange(of: emailFocused) { _, newValue in
        if newValue {
          Task {
            try? await client.signIn.passkeyAutoFill()
          }
        }
      }
  }
}
```
