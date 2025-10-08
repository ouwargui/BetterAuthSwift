import BetterAuth
import Foundation

public struct UserWithPhoneNumber: UserProtocol {
  public let id: String
  public let email: String
  public let name: String
  public let image: String?
  public let emailVerified: Bool
  public let createdAt: Date
  public let updatedAt: Date
  public let phoneNumber: String
  public let phoneNumberVerified: Bool

  public init(
    id: String,
    email: String,
    name: String,
    image: String? = nil,
    emailVerified: Bool,
    createdAt: Date,
    updatedAt: Date,
    phoneNumber: String,
    phoneNumberVerified: Bool
  ) {
    self.id = id
    self.email = email
    self.name = name
    self.image = image
    self.emailVerified = emailVerified
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.phoneNumber = phoneNumber
    self.phoneNumberVerified = phoneNumberVerified
  }
}

public struct PhoneNumberSignInPhoneNumberRequest: Codable, Sendable {
  public let phoneNumber: String
  public let password: String
  public let rememberMe: Bool?

  public init(phoneNumber: String, password: String, rememberMe: Bool?) {
    self.phoneNumber = phoneNumber
    self.password = password
    self.rememberMe = rememberMe
  }
}

public struct PhoneNumberSignInPhoneNumberResponse: Codable, Sendable {
  public let user: UserWithPhoneNumber
  public let token: String

  public init(user: UserWithPhoneNumber, token: String) {
    self.user = user
    self.token = token
  }
}

public struct PhoneNumberSendOTPRequest: Codable, Sendable {
  public let phoneNumber: String

  public init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }
}

public struct PhoneNumberSendOTPResponse: Codable, Sendable {
  public let message: String

  public init(message: String) {
    self.message = message
  }
}

public struct PhoneNumberVerifyRequest: Codable, Sendable {
  public let phoneNumber: String
  public let code: String
  public let disableSession: Bool?
  public let updatePhoneNumber: Bool?

  public init(
    phoneNumber: String,
    code: String,
    disableSession: Bool?,
    updatePhoneNumber: Bool?
  ) {
    self.phoneNumber = phoneNumber
    self.code = code
    self.disableSession = disableSession
    self.updatePhoneNumber = updatePhoneNumber
  }
}

public struct PhoneNumberVerifyResponse: Codable, Sendable {
  public let status: Bool
  public let token: String?
  public let user: UserWithPhoneNumber?

  public init(status: Bool, token: String?, user: UserWithPhoneNumber?) {
    self.status = status
    self.token = token
    self.user = user
  }
}

public struct PhoneNumberForgetPasswordRequest: Codable, Sendable {
  public let phoneNumber: String

  public init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }
}

public struct PhoneNumberForgetPasswordResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct PhoneNumberRequestPasswordResetRequest: Codable, Sendable {
  public let phoneNumber: String

  public init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }
}

public struct PhoneNumberRequestPasswordResetResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct PhoneNumberResetPasswordRequest: Codable, Sendable {
  public let otp: String
  public let phoneNumber: String
  public let password: String

  public init(otp: String, phoneNumber: String, password: String) {
    self.otp = otp
    self.phoneNumber = phoneNumber
    self.password = password
  }
}

public struct PhoneNumberResetPasswordResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}
