import Foundation

public struct SignUpEmailRequest: Codable, Sendable {
  public let email: String
  public let password: String
  public let name: String
  public let image: String?
  public let callbackURL: String?
  public let rememberMe: Bool?

  public init(
    email: String,
    password: String,
    name: String,
    image: String? = nil,
    callbackURL: String? = nil,
    rememberMe: Bool? = nil,
  ) {
    self.email = email
    self.password = password
    self.name = name
    self.image = image
    self.callbackURL = callbackURL
    self.rememberMe = rememberMe
  }
}

public struct SignUpEmailResponse: Codable, Sendable {
  public let user: User
  public let token: String
}

public struct SignInEmailRequest: Codable, Sendable {
  public let email: String
  public let password: String
  public let callbackURL: String?
  public let rememberMe: Bool?

  public init(
    email: String,
    password: String,
    callbackURL: String? = nil,
    rememberMe: Bool? = nil,
  ) {
    self.email = email
    self.password = password
    self.callbackURL = callbackURL
    self.rememberMe = rememberMe
  }
}

public struct SignInEmailResponse: Codable, Sendable {
  public let user: User
  public let token: String
  public let redirect: Bool
  public let url: String?
}

public struct SignInSocialRequest: Codable, Sendable {
  public let provider: String
  public let callbackURL: String?
  public let newUserCallbackURL: String?
  public let errorCallbackURL: String?
  public let idToken: IDToken?
  public let disableRedirect: Bool?
  public let scopes: [String]?
  public let requestSignUp: Bool?
  public let loginHint: String?

  public struct IDToken: Codable, Sendable {
    public let token: String
    public let nonce: String?
    public let accessToken: String?
    public let refreshToken: String?
    public let expiresAt: Date?
  }

  public init(
    provider: String,
    callbackURL: String? = nil,
    newUserCallbackURL: String? = nil,
    errorCallbackURL: String? = nil,
    idToken: IDToken? = nil,
    disableRedirect: Bool? = nil,
    scopes: [String]? = nil,
    requestSignUp: Bool? = nil,
    loginHint: String? = nil,
  ) {
    self.provider = provider
    self.callbackURL = callbackURL
    self.newUserCallbackURL = newUserCallbackURL
    self.errorCallbackURL = errorCallbackURL
    self.idToken = idToken
    self.disableRedirect = disableRedirect
    self.scopes = scopes
    self.requestSignUp = requestSignUp
    self.loginHint = loginHint
  }
}

public struct SignOutResponse: Codable, Sendable {
  public let success: Bool
}
