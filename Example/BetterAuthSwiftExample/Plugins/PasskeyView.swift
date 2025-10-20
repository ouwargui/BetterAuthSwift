import BetterAuth
import BetterAuthPasskey
import SwiftUI

struct PasskeyView: View {
  @EnvironmentObject var client: BetterAuthClient

  @State private var email: String = ""
  @State private var password: String = ""
  @State private var isLoading: Bool = false
  @State private var errorMessage: String?

  enum Field {
    case email, password
  }

  @FocusState private var usernameFocused: Bool

  var body: some View {
    VStack(spacing: 24) {
      Spacer()

      if let user = client.session.data?.user {
        // MARK: - Authenticated state
        VStack(spacing: 12) {
          Text("👋 Hello, \(user.name)")
            .font(.title3)
            .fontWeight(.semibold)

          if let passkeys = client.passkey.userPasskeys.data, !passkeys.isEmpty
          {
            List(passkeys) { passkey in
              VStack(alignment: .leading) {
                Text(passkey.id)
                  .fontWeight(.medium)
                Text(
                  "Created: \(passkey.createdAt.formatted(date: .abbreviated, time: .shortened))"
                )
                .font(.caption)
                .foregroundColor(.secondary)
              }
              .padding(.vertical, 4)
            }
            .frame(maxHeight: 250)
          } else {
            Text("No passkeys yet")
              .foregroundColor(.secondary)
          }

          Button(action: addPasskey) {
            Label("Add new Passkey", systemImage: "key.fill")
          }
          .buttonStyle(.borderedProminent)
          .disabled(isLoading)

          Button("Sign out") {
            Task { try await client.signOut() }
          }
          .foregroundColor(.red)
        }

      } else {
        // MARK: - Signed-out state
        VStack(spacing: 16) {
          TextField("Email", text: $email)
            .textContentType(.username)
            .textFieldStyle(.roundedBorder)
            .focused($usernameFocused)
            .onChange(of: usernameFocused) { _, newValue in
              #if os(iOS) || os(visionOS)
                if newValue {
                  Task {
                    do {
                      _ = try await client.signIn.passkeyAutoFill()
                    } catch {
                      print(error)
                    }
                  }
                }
              #endif
            }

          SecureField("Password", text: $password)
            .textContentType(.password)
            .textFieldStyle(.roundedBorder)

          if let errorMessage {
            Text(errorMessage)
              .foregroundColor(.red)
              .font(.footnote)
          }

          VStack(spacing: 10) {
            Button(action: signIn) {
              Label("Sign In", systemImage: "person.fill")
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading || email.isEmpty || password.isEmpty)

            Button(action: signUp) {
              Label("Sign Up", systemImage: "person.badge.plus")
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(isLoading || email.isEmpty || password.isEmpty)

            Button(action: signInWithPasskey) {
              Label("Sign in with Passkey", systemImage: "key.fill")
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
          }
        }
      }

      Spacer()
    }
    .padding(.horizontal, 24)
    .task {
      // Refresh passkey list once user logs in
      if client.session.data?.user != nil {
        await client.passkey.userPasskeys.refreshPasskeys()
      }
    }
  }

  // MARK: - Actions

  private func signIn() {
    Task {
      isLoading = true
      do {
        _ = try await client.signIn.email(
          with: .init(email: email, password: password)
        )
      } catch {
        errorMessage = error.localizedDescription
      }
      isLoading = false
    }
  }

  private func signUp() {
    Task {
      isLoading = true
      do {
        _ = try await client.signUp.email(
          with: .init(
            email: email,
            password: password,
            name: email.components(separatedBy: "@").first ?? "User"
          )
        )
      } catch {
        errorMessage = error.localizedDescription
      }
      isLoading = false
    }
  }

  private func signInWithPasskey() {
    Task {
      isLoading = true
      do {
        _ = try await client.signIn.passkey()
      } catch {
        errorMessage = error.localizedDescription
      }
      isLoading = false
    }
  }

  private func addPasskey() {
    Task {
      isLoading = true
      do {
        _ = try await client.passkey.addPasskey()
      } catch {
        errorMessage = error.localizedDescription
        print(error)
      }
      isLoading = false
    }
  }
}
