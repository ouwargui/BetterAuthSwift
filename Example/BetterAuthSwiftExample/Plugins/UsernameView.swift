import SwiftUI
import BetterAuth
import BetterAuthUsername

struct UsernameView: View {
  @EnvironmentObject var client: BetterAuthClient
  
  @State private var username = ""
  @State private var password = ""
  @State private var email = ""
  @State private var name = ""
  @State private var isRegistering = false
  @State private var isLoading = false
  @State private var errorMessage: String?
  
  var body: some View {
    VStack(spacing: 24) {
      if let user = client.session.data?.user {
        // MARK: - Logged-in State
        HStack(alignment: .center, spacing: 16) {
          AsyncImage(url: URL(string: user.image ?? "")) { image in
            image.resizable()
          } placeholder: {
            Circle()
              .fill(Color.gray.opacity(0.3))
              .overlay(
                Image(systemName: "person.fill")
                  .foregroundColor(.gray)
              )
          }
          .frame(width: 60, height: 60)
          .clipShape(Circle())
          .shadow(radius: 2)

          VStack(alignment: .leading, spacing: 4) {
            Text(user.displayUsername ?? user.username ?? user.name)
              .font(.headline)
              .foregroundColor(.primary)
            
            Text(user.email)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }

          Spacer()

          Button {
            Task {
              try? await client.signOut()
            }
          } label: {
            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
              .font(.subheadline.bold())
              .foregroundColor(.white)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(Capsule().fill(Color.red.gradient))
          }
          .buttonStyle(.plain)
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemFill))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )

        Text("Welcome, \(user.displayUsername ?? user.username ?? user.name)!")
          .font(.title3)
          .fontWeight(.semibold)
      
      } else {
        // MARK: - Login / Register Section
        VStack(spacing: 16) {
          Image(systemName: "person.badge.key.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .foregroundStyle(.tint)
            .padding(.bottom, 6)
          
          Text(isRegistering ? "Create your account" : "Sign in with username")
            .font(.headline)
          
          VStack(spacing: 10) {
            TextField("Username", text: $username)
              .padding(12)
              .background(Color(.secondarySystemFill))
              .cornerRadius(8)
              .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
              .padding(12)
              .background(Color(.secondarySystemFill))
              .cornerRadius(8)
          }
          
          if isRegistering {
            VStack(spacing: 10) {
              TextField("Email", text: $email)
                .padding(12)
                .background(Color(.secondarySystemFill))
                .cornerRadius(8)
              
              TextField("Full Name", text: $name)
                .padding(12)
                .background(Color(.secondarySystemFill))
                .cornerRadius(8)
            }
            .transition(.opacity)
          }
          
          VStack(spacing: 12) {
            Button {
              isRegistering ? register() : login()
            } label: {
              Label(
                isRegistering ? "Create Account" : "Sign In",
                systemImage: isRegistering ? "person.fill.badge.plus" : "arrow.right.circle.fill"
              )
              .font(.headline)
              .foregroundColor(.white)
              .padding(.horizontal, 40)
              .padding(.vertical, 10)
              .background(Capsule().fill(Color.accentColor.gradient))
            }
            .disabled(isLoading)
            
            Button(isRegistering ? "Already have an account? Sign In" :
                    "Don’t have an account? Register") {
              withAnimation { isRegistering.toggle() }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
          }
          
          if let errorMessage = errorMessage {
            Text(errorMessage)
              .foregroundColor(.red)
              .font(.footnote)
              .padding(.top, 4)
          }
        }
        .padding()
        .frame(maxWidth: 380)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemFill))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(alignment: .center) {
          if isLoading {
            ProgressView()
              .progressViewStyle(.circular)
              .scaleEffect(1.3)
          }
        }
        .animation(.easeInOut, value: isRegistering)
      }
    }
    .padding()
    .animation(.spring(duration: 0.35), value: client.session.data?.user.id)
  }
}

// MARK: - Logic
private extension UsernameView {
  func login() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.signIn.username(
          with: UsernameSignInUsernameRequest(
            username: username,
            password: password
          )
        )
      } catch {
        errorMessage = "Login failed: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
  
  func register() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.signUp.email(
          with: UsernameSignUpEmailRequest(
            email: email,
            password: password,
            name: name,
            username: username,
            displayUsername: username
          )
        )
      } catch {
        errorMessage = "Registration failed: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
}
