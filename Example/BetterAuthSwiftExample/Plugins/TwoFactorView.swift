import BetterAuth
import SwiftUI
import BetterAuthTwoFactor

let random = String.randomString(length: 10)

struct TwoFactorView: View {
  @EnvironmentObject var client: BetterAuthClient
  @State private var errorMessage: String? = nil
  @State private var isLoading: Bool = false

  private let email: String = "\(random)@test.com"
  private let password: String = "12345678"
  
  @State private var code: String = ""
  @State private var show2fa: Bool = false
  
  private var twoFactorEnabled: String {
    guard let twoFactor = client.user?.twoFactorEnabled else {
      return "false"
    }
    
    return twoFactor.description
  }

  var body: some View {
    VStack(spacing: 24) {
      if let user = client.user {
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
            Text(user.name)
              .font(.headline)
              .foregroundColor(.primary)
            Text("2fa enabled: \(twoFactorEnabled)")
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
          
          Spacer()
          
          Button {
            Task {
              self.enable2fa()
            }
          } label: {
            Label("Enable 2fa", systemImage: "lock.shield")
              .font(.subheadline.bold())
              .foregroundColor(.white)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(Capsule().fill(Color.green.gradient))
          }
          .buttonStyle(.plain)
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
        
        if let errorMessage = errorMessage {
          Text(errorMessage)
            .foregroundStyle(.red)
        }
        
      } else {
        VStack(spacing: 12) {
          Image(systemName: "person.crop.circle.badge.plus")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .foregroundStyle(.tint)
            .padding(.bottom, 4)
          
          Text("You’re not signed in yet")
            .font(.headline)
          
          if self.show2fa {
            TextField("Code", text: $code)
              .textContentType(.oneTimeCode)

            Button("Verify 2fa") {
              Task {
                self.verify2fa()
              }
            }
          } else {
            Button("Sign in") {
              Task {
                self.signin()
              }
            }
            
            Button("Sign up") {
              Task {
                self.signup()
              }
            }
          }
        }
        .padding()
      }
    }
  }
  
  private func signin() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        let res = try await client.signIn.email(with: .init(email: email, password: password))
        switch res.twoFactorResponse {
        case .twoFactorRedirect(let twoFA):
          _ = try await client.twoFactor.sendOtp(with: .init())
          self.show2fa = twoFA
        default:
          break
        }
      } catch {
        errorMessage = "Failed to signin: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
  
  private func verify2fa() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.twoFactor.verifyOtp(with: .init(code: code, trustDevice: false))
      } catch {
        errorMessage = "Failed to verify otp: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }

  private func signup() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.signUp.email(
          with: .init(email: email, password: password, name: "Test")
        )
      } catch {
        errorMessage = "Failed to signup: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
  
  private func enable2fa() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.twoFactor.enable(with: .init(password: password))
      } catch {
        errorMessage = "Failed to enable 2fa: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }

}
