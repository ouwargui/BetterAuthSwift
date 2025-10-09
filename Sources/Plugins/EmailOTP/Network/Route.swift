import BetterAuth
import Foundation

public enum BetterAuthEmailOTPRoute: AuthRoutable {
  case emailOTPSendVerificationOTP
  case emailOTPCheckVerificationOTP
  case emailOTPVerifyEmail
  case emailOTPResetPassword
  case forgetPasswordEmailOTP
  case signInEmailOTP

  public var path: String {
    switch self {
    case .emailOTPSendVerificationOTP:
      "/email-otp/send-verification-otp"
    case .emailOTPCheckVerificationOTP:
      "/email-otp/check-verification-otp"
    case .emailOTPVerifyEmail:
      "/email-otp/verify-email"
    case .emailOTPResetPassword:
      "/email-otp/reset-password"
    case .forgetPasswordEmailOTP:
      "/forget-password/email-otp"
    case .signInEmailOTP:
      "/sign-in/email-otp"
    }
  }

  public var method: String {
    switch self {
    case .emailOTPSendVerificationOTP, .emailOTPCheckVerificationOTP,
      .emailOTPVerifyEmail, .emailOTPResetPassword, .forgetPasswordEmailOTP,
      .signInEmailOTP:
      "POST"
    }
  }
}
