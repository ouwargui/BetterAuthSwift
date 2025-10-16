import BetterAuth
import BetterAuthPasskey
import SwiftUI

struct PasskeyView: View {
  @EnvironmentObject var client: BetterAuthClient

  var body: some View {
    VStack {
      Spacer()

      if let user = client.user {
        Text("Hello \(user.name)")
        Button("Add passkey") {
          Task {
            do {
              let res = try await client.passkey.addPasskey()
              print(res.data)
            } catch {
              print(error)
            }
          }
        }
      } else {
        Button("Sign in with Passkey") {
          Task {
            Task {
              do {
                _ = try await client.signIn.passkey()
              } catch {
                print(error)
              }
            }
          }
        }
        Button("Sign up") {
          Task {
            _ = try await client.signUp.email(
              with: .init(
                email: "gui\(String.randomString(length: 5))@test.com",
                password: "12345667",
                name: "Gui"
              )
            )
          }
        }
      }

      Spacer()
    }
    .padding()
  }
}
