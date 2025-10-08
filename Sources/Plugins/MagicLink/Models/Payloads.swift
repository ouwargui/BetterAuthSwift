import BetterAuth
import Foundation

public struct MagicLinkSignInMagicLinkRequest: Codable, Sendable {
  public let email: String
  public let name: String?
  public let callbackURL: String?
  public let newUserCallbackURL: String?
  public let errorCallbackURL: String?

  public init(
    email: String,
    name: String? = nil,
    callbackURL: String? = nil,
    newUserCallbackURL: String? = nil,
    errorCallbackURL: String? = nil
  ) {
    self.email = email
    self.name = name
    self.callbackURL = callbackURL
    self.newUserCallbackURL = newUserCallbackURL
    self.errorCallbackURL = errorCallbackURL
  }
}

public struct MagicLinkSignInMagicLinkResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct MagicLinkVerifyRequest: Codable, Sendable {
  public let token: String
  public let callbackURL: String?
  public let newUserCallbackURL: String?
  public let errorCallbackURL: String?

  public init(
    token: String,
    callbackURL: String? = nil,
    newUserCallbackURL: String? = nil,
    errorCallbackURL: String? = nil
  ) {
    self.token = token
    self.callbackURL = callbackURL
    self.newUserCallbackURL = newUserCallbackURL
    self.errorCallbackURL = errorCallbackURL
  }
}

public struct MagicLinkVerifyResponse: Codable, Sendable {
  public let token: String
  public let user: User

  public init(token: String, user: User) {
    self.token = token
    self.user = user
  }
}
