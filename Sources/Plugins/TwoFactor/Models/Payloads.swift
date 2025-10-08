import BetterAuth
import Foundation

public struct TwoFactorEnableRequest: Codable, Sendable {
  public let password: String
  public let issuer: String?

  public init(password: String, issuer: String? = nil) {
    self.password = password
    self.issuer = issuer
  }
}

public struct TwoFactorEnableResponse: Codable, Sendable {
  public let totpURI: String
  public let backupCodes: [String]

  public init(totpURI: String, backupCodes: [String]) {
    self.totpURI = totpURI
    self.backupCodes = backupCodes
  }
}

public struct TwoFactorDisableRequest: Codable, Sendable {
  public let password: String

  public init(password: String) {
    self.password = password
  }
}

public struct TwoFactorDisableResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct TwoFactorGenerateBackupCodesRequest: Codable, Sendable {
  public let password: String

  public init(password: String) {
    self.password = password
  }
}

public struct TwoFactorGenerateBackupCodesResponse: Codable, Sendable {
  public let backupCodes: [String]
  public let status: Bool

  public init(backupCodes: [String], status: Bool) {
    self.backupCodes = backupCodes
    self.status = status
  }
}

public struct TwoFactorGetTotpURIRequest: Codable, Sendable {
  public let password: String

  public init(password: String) {
    self.password = password
  }
}

public struct TwoFactorGetTotpURIResponse: Codable, Sendable {
  public let totpURI: String

  public init(totpURI: String) {
    self.totpURI = totpURI
  }
}

public struct TwoFactorSendOTPRequest: Codable, Sendable {
  public let trustDevice: Bool?

  public init(trustDevice: Bool? = nil) {
    self.trustDevice = trustDevice
  }
}

public struct TwoFactorSendOTPResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct TwoFactorVerifyBackupCodeRequest: Codable, Sendable {
  public let code: String
  public let disableSession: Bool?
  public let trustDevice: Bool?

  public init(code: String, disableSession: Bool?, trustDevice: Bool?) {
    self.code = code
    self.disableSession = disableSession
    self.trustDevice = trustDevice
  }
}

public struct TwoFactorVerifyBackupCodeResponse: Codable, Sendable {
  public let token: String?
  public let user: User

  public init(token: String?, user: User) {
    self.token = token
    self.user = user
  }
}

public struct TwoFactorVerifyOTPRequest: Codable, Sendable {
  public let code: String
  public let trustDevice: Bool?

  public init(code: String, trustDevice: Bool?) {
    self.code = code
    self.trustDevice = trustDevice
  }
}

public struct TwoFactorVerifyOTPResponse: Codable, Sendable {
  public let token: String
  public let user: User

  public init(token: String, user: User) {
    self.token = token
    self.user = user
  }
}

public struct TwoFactorVerifyTOTPRequest: Codable, Sendable {
  public let code: String
  public let trustDevice: Bool?

  public init(code: String, trustDevice: Bool?) {
    self.code = code
    self.trustDevice = trustDevice
  }
}

public struct TwoFactorVerifyTOTPResponse: Codable, Sendable {
  public let token: String
  public let user: User

  public init(token: String, user: User) {
    self.token = token
    self.user = user
  }
}

public typealias TwoFactorRedirect = Bool

public struct TwoFactorSignInResponse: Codable, Sendable {
  public let twoFactorRedirect: TwoFactorRedirect

  public init(twoFactorRedirect: TwoFactorRedirect) {
    self.twoFactorRedirect = twoFactorRedirect
  }
}
