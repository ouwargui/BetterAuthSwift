import BetterAuth
import Foundation

public enum BetterAuthPhoneNumberRoute: AuthRoutable {
  case signInPhoneNumber
  case phoneNumberSendOTP
  case phoneNumberVerify
  case phoneNumberForgetPassword
  case phoneNumberRequestPasswordReset
  case phoneNumberResetPassword

  public var path: String {
    switch self {
    case .signInPhoneNumber:
      "/sign-in/phone-number"
    case .phoneNumberSendOTP:
      "/phone-number/send-otp"
    case .phoneNumberVerify:
      "/phone-number/verify"
    case .phoneNumberForgetPassword:
      "/phone-number/forget-password"
    case .phoneNumberRequestPasswordReset:
      "/phone-number/request-password-reset"
    case .phoneNumberResetPassword:
      "/phone-number/reset-password"
    }
  }

  public var method: String {
    switch self {
    case .signInPhoneNumber, .phoneNumberSendOTP, .phoneNumberVerify,
      .phoneNumberForgetPassword, .phoneNumberRequestPasswordReset,
      .phoneNumberResetPassword:
      "POST"
    }
  }
}
