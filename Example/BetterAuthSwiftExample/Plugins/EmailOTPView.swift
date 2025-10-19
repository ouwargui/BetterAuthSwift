import SwiftUI
import BetterAuth
import BetterAuthEmailOTP

struct EmailOTPView: View {
  @EnvironmentObject var client: BetterAuthClient

  @State private var email = ""
  @State private var otp = ""
  @State private var isCodeSent = false
  @State private var isLoading = false
  @State private var errorMessage: String?
  @State private var successMessage: String?

  var body: some View {
    VStack(spacing: 24) {
      if let user = client.session.data?.user {
        // MARK: - Logged In
        HStack(alignment: .center, spacing: 16) {
          AsyncImage(url: URL(string: user.image ?? "")) { image in
            image.resizable()
          } placeholder: {
            Circle()
              .fill(Color.gray.opacity(0.3))
              .overlay(Image(systemName: "person.fill").foregroundColor(.gray))
          }
          .frame(width: 60, height: 60)
          .clipShape(Circle())
          .shadow(radius: 2)

          VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
              .font(.headline)
              .foregroundColor(.primary)
            Text(user.email)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }

          Spacer()

          Button {
            Task { try? await client.signOut() }
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
            .fill(Color(.secondarySystemBackground))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )

        Text("Welcome, \(user.name)!")
          .font(.title3)
          .fontWeight(.semibold)

      } else {
        // MARK: - Sign In Through Email OTP
        VStack(spacing: 16) {
          Image(systemName: "envelope.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 64, height: 64)
            .foregroundStyle(.tint)
            .padding(.bottom, 6)

          Text("Sign in with Email OTP")
            .font(.headline)

          TextField("Email address", text: $email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .disabled(isCodeSent)
          
          if !isCodeSent {
            Button {
              sendOTP()
            } label: {
              Label("Send OTP", systemImage: "paperplane.fill")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.accentColor.gradient))
            }
            .disabled(email.isEmpty || isLoading)
          }

          if isCodeSent {
            VStack(spacing: 10) {
              SecureField("Enter OTP code", text: $otp)
                .keyboardType(.numberPad)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

              Button {
                verifyOTP()
              } label: {
                Label("Verify", systemImage: "checkmark.circle.fill")
                  .font(.headline)
                  .foregroundColor(.white)
                  .padding(.horizontal, 40)
                  .padding(.vertical, 10)
                  .background(Capsule().fill(Color.green.gradient))
              }
              .disabled(otp.isEmpty || isLoading)
            }
            .transition(.opacity)
          }

          if let successMessage = successMessage {
            Text(successMessage)
              .foregroundColor(.green)
              .font(.footnote)
              .padding(.top, 4)
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
            .fill(Color(.tertiarySystemBackground))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(alignment: .center) {
          if isLoading {
            ProgressView()
              .progressViewStyle(.circular)
              .scaleEffect(1.3)
          }
        }
        .animation(.easeInOut, value: isCodeSent)
      }
    }
    .padding()
    .animation(.spring(duration: 0.35), value: client.session.data?.user.id)
  }

  // MARK: - Logic

  private func sendOTP() {
    Task {
      isLoading = true
      errorMessage = nil
      successMessage = nil
      do {
        let response = try await client.emailOtp.sendVerificationOtp(
          with: EmailOTPSendVerificationOTPRequest(email: email, type: .signIn)
        )
        if response.data.success {
          withAnimation { isCodeSent = true }
          successMessage = "Verification code sent to \(email)"
        } else {
          errorMessage = "Failed to send verification code"
        }
      } catch {
        errorMessage = "Error: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }

  private func verifyOTP() {
    Task {
      isLoading = true
      errorMessage = nil
      successMessage = nil
      do {
        _ = try await client.signIn.emailOtp(
          with: .init(email: email, otp: otp)
        )
      } catch {
        errorMessage = "Verification failed: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
}
