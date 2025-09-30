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
