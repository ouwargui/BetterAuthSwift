import BetterAuth
import Foundation

public struct GenericOAuthSignInRequest: Codable, Sendable {
  public let providerId: String
  public let callbackURL: String?
  public let errorCallbackURL: String?
  public let newUserCallbackURL: String?
  public let disableRedirect: Bool?
  public let scopes: [String]?
  public let requestSignUp: Bool?
  public let additionalData: [String: AnyCodable]?

  public init(
    providerId: String,
    callbackURL: String? = nil,
    errorCallbackURL: String? = nil,
    newUserCallbackURL: String? = nil,
    disableRedirect: Bool? = nil,
    scopes: [String]? = nil,
    requestSignUp: Bool? = nil,
    additionalData: [String: AnyCodable]? = nil
  ) {
    self.providerId = providerId
    self.callbackURL = callbackURL
    self.errorCallbackURL = errorCallbackURL
    self.newUserCallbackURL = newUserCallbackURL
    self.disableRedirect = disableRedirect
    self.scopes = scopes
    self.requestSignUp = requestSignUp
    self.additionalData = additionalData
  }
}

public struct GenericOAuthSignInResponse: Codable, Sendable {
  public let url: String?
  public let redirect: Bool

  public init(url: String?, redirect: Bool) {
    self.url = url
    self.redirect = redirect
  }
}

public struct GenericOAuthLinkRequest: Codable, Sendable {
  public let providerId: String
  public let callbackURL: String
  public let scopes: [String]?
  public let errorCallbackURL: String?

  public init(
    providerId: String,
    callbackURL: String,
    scopes: [String]? = nil,
    errorCallbackURL: String? = nil
  ) {
    self.providerId = providerId
    self.callbackURL = callbackURL
    self.scopes = scopes
    self.errorCallbackURL = errorCallbackURL
  }
}

public struct GenericOAuthLinkResponse: Codable, Sendable {
  public let url: String
  public let redirect: Bool

  public init(url: String, redirect: Bool) {
    self.url = url
    self.redirect = redirect
  }
}
