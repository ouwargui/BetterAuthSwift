import BetterAuth
import BetterAuthPhoneNumber
import SwiftUI

struct PhoneNumberView: View {
  @EnvironmentObject var client: BetterAuthClient

  @State private var phoneNumber = ""
  @State private var otpCode = ""
  @State private var isOTPSent = false
  @State private var isLoading = false
  @State private var errorMessage: String?

  var body: some View {
    VStack(spacing: 24) {
      if let user = client.session.data?.user {
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
            if let phone = user.phoneNumber {
              Text(phone)
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
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

        Text("Welcome back, \(user.name)!")
          .font(.title3)
          .fontWeight(.semibold)

      } else {
        VStack(spacing: 16) {
          Image(systemName: "phone.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .foregroundStyle(.tint)
            .padding(.bottom, 6)

          Text("Sign in with your phone number")
            .font(.headline)

          HStack {
            TextField("+1 (555) 123-4567", text: $phoneNumber)
              .padding(12)
              .background(Color(.secondarySystemFill))
              .cornerRadius(8)
              .disabled(isOTPSent)
              .textContentType(.telephoneNumber)

            if !isOTPSent {
              Button {
                sendOTP()
              } label: {
                Label("Send OTP", systemImage: "paperplane.fill")
                  .font(.subheadline.bold())
              }
              .buttonStyle(.borderedProminent)
              .disabled(phoneNumber.isEmpty || isLoading)
            }
          }

          if isOTPSent {
            VStack(spacing: 10) {
              SecureField("Enter OTP Code", text: $otpCode)
                .padding(12)
                .background(Color(.secondarySystemFill))
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
              .disabled(otpCode.isEmpty || isLoading)
            }
            .transition(.opacity)
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
            .fill(Color(.tertiarySystemFill))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(alignment: .center) {
          if isLoading {
            ProgressView()
              .progressViewStyle(.circular)
              .scaleEffect(1.3)
          }
        }
        .animation(.easeInOut, value: isOTPSent)
      }
    }
    .padding()
    .animation(.spring(duration: 0.35), value: client.session.data?.user.id)
  }

  private func sendOTP() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.phoneNumber.sendOtp(
          with: .init(phoneNumber: phoneNumber)
        )
        withAnimation { isOTPSent = true }
      } catch {
        errorMessage = "Failed to send OTP: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }

  private func verifyOTP() {
    Task {
      isLoading = true
      errorMessage = nil
      do {
        _ = try await client.phoneNumber.verify(
          with: .init(
            phoneNumber: phoneNumber,
            code: otpCode
          )
        )
        isOTPSent = false
        phoneNumber = ""
        otpCode = ""
      } catch {
        errorMessage = "Verification failed: \(error.localizedDescription)"
      }
      isLoading = false
    }
  }
}
