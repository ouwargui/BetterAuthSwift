import BetterAuth
import Foundation

public enum EmailOTPType: String, Codable, Sendable {
  case emailVerification = "email-verification"
  case signIn = "sign-in"
  case forgetPassword = "forget-password"
}

public struct EmailOTPSendVerificationOTPRequest: Codable, Sendable {
  public let email: String
  public let type: EmailOTPType

  public init(email: String, type: EmailOTPType) {
    self.email = email
    self.type = type
  }
}

public struct EmailOTPSendVerificationOTPResponse: Codable, Sendable {
  public let success: Bool

  public init(success: Bool) {
    self.success = success
  }
}

public struct EmailOTPCheckVerificationOTPRequest: Codable, Sendable {
  public let email: String
  public let type: EmailOTPType
  public let otp: String

  public init(email: String, type: EmailOTPType, otp: String) {
    self.email = email
    self.type = type
    self.otp = otp
  }
}

public struct EmailOTPCheckVerificationOTPResponse: Codable, Sendable {
  public let success: Bool

  public init(success: Bool) {
    self.success = success
  }
}

public struct EmailOTPVerifyEmailRequest: Codable, Sendable {
  public let email: String
  public let otp: String

  public init(email: String, otp: String) {
    self.email = email
    self.otp = otp
  }
}

public struct EmailOTPVerifyEmailResponse: Codable, Sendable {
  public let status: Bool
  public let user: User?
  public let token: String?

  public init(status: Bool, user: User? = nil, token: String? = nil) {
    self.status = status
    self.user = user
    self.token = token
  }
}

public struct EmailOTPResetPasswordRequest: Codable, Sendable {
  public let email: String
  public let otp: String
  public let password: String

  public init(email: String, otp: String, password: String) {
    self.email = email
    self.otp = otp
    self.password = password
  }
}

public struct EmailOTPResetPasswordResponse: Codable, Sendable {
  public let success: Bool

  public init(success: Bool) {
    self.success = success
  }
}

public struct EmailOTPForgetPasswordEmailOTPRequest: Codable, Sendable {
  public let email: String

  public init(email: String) {
    self.email = email
  }
}

public struct EmailOTPForgetPasswordEmailOTPResponse: Codable, Sendable {
  public let success: Bool

  public init(success: Bool) {
    self.success = success
  }
}

public struct EmailOTPSignInEmailOTPRequest: Codable, Sendable {
  public let email: String
  public let otp: String

  public init(email: String, otp: String) {
    self.email = email
    self.otp = otp
  }
}

public struct EmailOTPSignInEmailOTPResponse: Codable, Sendable {
  public let user: User
  public let token: String

  public init(user: User, token: String) {
    self.user = user
    self.token = token
  }
}
