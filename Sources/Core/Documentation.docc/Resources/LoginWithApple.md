# Signing in with Apple

Learn how to use the `idToken` flow to natively sign with Apple

## 1. Setup the server

Follow the steps on the official [Better Auth docs](https://www.better-auth.com/docs/authentication/apple) until the "usage" step.

## 2. Add the `Sign in with Apple` entitlement to your app

Enable the Sign in with Apple capability in Xcode. You can follow [these steps](https://developer.apple.com/documentation/authenticationservices/implementing-user-authentication-with-sign-in-with-apple#Configure-the-Sample-Code-Project) to do this.

## 3. Use the result from `SignInWithAppleButton` to get the `idToken`

```swift
import AuthenticationServices
import BetterAuth
import SwiftUI

struct ContentView: View {
  @StateObject private var client = BetterAuthClient(
    baseURL: URL(string: "http://your-api-url.com")!
  )

  var body: some View {
    VStack {
      if let user = client.session.data?.user {
        Text("Hello, \(user.name)")
      }

      Spacer()

      if client.session.data != nil {
        SignInWithAppleButton(.signIn) { request in
          request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
          Task {
            switch result {
            case .success(let authorization):
              guard
                let appleIdCredential = authorization.credential
                  as? ASAuthorizationAppleIDCredential,
                let identityTokenData = appleIdCredential.identityToken,
                let identityToken = String(
                  data: identityTokenData,
                  encoding: .utf8
                )
              else {
                print("failed to get idtoken")
                return
              }

              let res = try await client.signIn.social(
                with: .init(
                  provider: "apple",
                  idToken: .init(token: identityToken)
                )
              )

            case .failure(let error):
              print(
                "sign in with apple failed \(error.localizedDescription)"
              )
            }

          }
        }
        .frame(height: 50)
      }
    }
    .padding()
  }
}
```
