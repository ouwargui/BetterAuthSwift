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

  public init(user: User, token: String) {
    self.user = user
    self.token = token
  }
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

  public init(user: User, token: String, redirect: Bool, url: String?) {
    self.user = user
    self.token = token
    self.redirect = redirect
    self.url = url
  }
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

    public init(
      token: String,
      nonce: String? = nil,
      accessToken: String? = nil,
      refreshToken: String? = nil,
      expiresAt: Date? = nil
    ) {
      self.token = token
      self.nonce = nonce
      self.accessToken = accessToken
      self.refreshToken = refreshToken
      self.expiresAt = expiresAt
    }
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

public struct SignInSocialResponse: Codable, Sendable {
  public let redirect: Bool
  public let token: String?
  public let url: String?

  public init(redirect: Bool, token: String?, url: String?) {
    self.redirect = redirect
    self.token = token
    self.url = url
  }
}

public struct SignOutResponse: Codable, Sendable {
  public let success: Bool

  public init(success: Bool) {
    self.success = success
  }
}

public struct ForgetPasswordRequest: Codable, Sendable {
  public let email: String
  public let redirectTo: String?

  public init(email: String, redirectTo: String?) {
    self.email = email
    self.redirectTo = redirectTo
  }
}

public struct ForgetPasswordResponse: Codable, Sendable {
  public let status: Bool
  public let message: String

  public init(status: Bool, message: String) {
    self.status = status
    self.message = message
  }
}

public struct ResetPasswordRequest: Codable, Sendable {
  public let token: String?
  public let newPassword: String

  public init(token: String?, newPassword: String) {
    self.token = token
    self.newPassword = newPassword
  }
}

public struct ResetPasswordResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct VerifyEmailRequest: Codable, Sendable {
  public let token: String
  public let callbackURL: String?

  public init(token: String, callbackURL: String?) {
    self.token = token
    self.callbackURL = callbackURL
  }
}

public struct VerifyEmailResponse: Codable, Sendable {
  public let user: User
  public let status: Bool

  public init(user: User, status: Bool) {
    self.user = user
    self.status = status
  }
}

public struct SendVerificationEmailRequest: Codable, Sendable {
  public let email: String
  public let callbackURL: String?

  public init(email: String, callbackURL: String?) {
    self.email = email
    self.callbackURL = callbackURL
  }
}

public struct SendVerificationEmailResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct ChangeEmailRequest: Codable, Sendable {
  public let newEmail: String
  public let callbackURL: String?

  public init(newEmail: String, callbackURL: String?) {
    self.newEmail = newEmail
    self.callbackURL = callbackURL
  }
}

public struct ChangeEmailResponse: Codable, Sendable {
  public let status: Bool
  public let message: String

  public init(status: Bool, message: String) {
    self.status = status
    self.message = message
  }
}

public struct ChangePasswordRequest: Codable, Sendable {
  public let currentPassword: String
  public let newPassword: String
  public let revokeOtherSessions: Bool?

  public init(
    currentPassword: String,
    newPassword: String,
    revokeOtherSessions: Bool?
  ) {
    self.currentPassword = currentPassword
    self.newPassword = newPassword
    self.revokeOtherSessions = revokeOtherSessions
  }
}

public struct ChangePasswordResponse: Codable, Sendable {
  public let token: String?
  public let user: User

  public init(token: String?, user: User) {
    self.token = token
    self.user = user
  }
}

public struct UpdateUserRequest: Codable, Sendable {
  public let image: String?
  public let name: String?

  public init(image: String?, name: String?) {
    self.image = image
    self.name = name
  }
}

public struct UpdateUserResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct DeleteUserRequest: Codable, Sendable {
  public let token: String?
  public let password: String?
  public let callbackURL: String?

  public init(token: String?, password: String?, callbackURL: String?) {
    self.token = token
    self.password = password
    self.callbackURL = callbackURL
  }
}

public struct DeleteUserResponse: Codable, Sendable {
  public let success: Bool
  public let message: String

  public init(success: Bool, message: String) {
    self.success = success
    self.message = message
  }
}

public struct RequestPasswordResetRequest: Codable, Sendable {
  public let email: String
  public let redirectTo: String?

  public init(email: String, redirectTo: String?) {
    self.email = email
    self.redirectTo = redirectTo
  }
}

public struct RequestPasswordResetResponse: Codable, Sendable {
  public let status: Bool
  public let message: String

  public init(status: Bool, message: String) {
    self.status = status
    self.message = message
  }
}

public typealias ListSessionResponse = [SessionData]

public struct RevokeSessionRequest: Codable, Sendable {
  public let token: String

  public init(token: String) {
    self.token = token
  }
}

public struct RevokeSessionResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct RevokeSessionsResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct RevokeOtherSessionsResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct LinkSocialRequest: Codable, Sendable {
  public let provider: String
  public let callbackURL: String?
  public let disableRedirect: Bool?
  public let errorCallbackURL: String?
  public let idToken: String?
  public let requestSignUp: Bool?
  public let scopes: [String]?

  public init(
    provider: String,
    callbackURL: String?,
    disableRedirect: Bool?,
    errorCallbackURL: String?,
    idToken: String?,
    requestSignUp: Bool?,
    scopes: [String]?
  ) {
    self.provider = provider
    self.callbackURL = callbackURL
    self.disableRedirect = disableRedirect
    self.errorCallbackURL = errorCallbackURL
    self.idToken = idToken
    self.requestSignUp = requestSignUp
    self.scopes = scopes
  }
}

public struct LinkSocialResponse: Codable, Sendable {
  public let url: String?
  public let redirect: Bool
  public let status: Bool?

  public init(url: String?, redirect: Bool, status: Bool?) {
    self.url = url
    self.redirect = redirect
    self.status = status
  }
}

public struct Account: Codable, Sendable {
  public let id: String
  public let provider: String
  public let createdAt: Date
  public let updatedAt: Date

  public init(id: String, provider: String, createdAt: Date, updatedAt: Date) {
    self.id = id
    self.provider = provider
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

public typealias ListAccountsResponse = [Account]

public struct UnlinkAccountRequest: Codable, Sendable {
  public let providerId: String
  public let accountId: String?

  public init(providerId: String, accountId: String?) {
    self.providerId = providerId
    self.accountId = accountId
  }
}

public struct UnlinkAccountResponse: Codable, Sendable {
  public let status: Bool

  public init(status: Bool) {
    self.status = status
  }
}

public struct RefreshTokenRequest: Codable, Sendable {
  public let providerId: String
  public let accountId: String?
  public let userId: String?

  public init(providerId: String, accountId: String?, userId: String?) {
    self.providerId = providerId
    self.accountId = accountId
    self.userId = userId
  }
}

public struct RefreshTokenResponse: Codable, Sendable {
  public let tokenType: String
  public let idToken: String
  public let accessToken: String
  public let refreshToken: String
  public let accessTokenExpiresAt: Date
  public let refreshTokenExpiresAt: Date

  public init(
    tokenType: String,
    idToken: String,
    accessToken: String,
    refreshToken: String,
    accessTokenExpiresAt: Date,
    refreshTokenExpiresAt: Date
  ) {
    self.tokenType = tokenType
    self.idToken = idToken
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.accessTokenExpiresAt = accessTokenExpiresAt
    self.refreshTokenExpiresAt = refreshTokenExpiresAt
  }
}

public struct GetAccessTokenRequest: Codable, Sendable {
  public let providerId: String
  public let accountId: String?
  public let userId: String?

  public init(providerId: String, accountId: String?, userId: String?) {
    self.providerId = providerId
    self.accountId = accountId
    self.userId = userId
  }
}

public struct GetAccessTokenResponse: Codable, Sendable {
  public let tokenType: String
  public let idToken: String
  public let accessToken: String
  public let refreshToken: String
  public let accessTokenExpiresAt: Date
  public let refreshTokenExpiresAt: Date

  public init(
    tokenType: String,
    idToken: String,
    accessToken: String,
    refreshToken: String,
    accessTokenExpiresAt: Date,
    refreshTokenExpiresAt: Date
  ) {
    self.tokenType = tokenType
    self.idToken = idToken
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.accessTokenExpiresAt = accessTokenExpiresAt
    self.refreshTokenExpiresAt = refreshTokenExpiresAt
  }
}

public struct AccountInfoRequest: Codable, Sendable {
  public let accountId: String

  public init(accountId: String) {
    self.accountId = accountId
  }
}

public struct AccountInfoResponse: Codable, Sendable {
  public let id: String
  public let email: String
  public let name: String
  public let image: String
  public let emailVerified: Bool
  public let data: [String: String]

  public init(
    id: String,
    email: String,
    name: String,
    image: String,
    emailVerified: Bool,
    data: [String: String]
  ) {
    self.id = id
    self.email = email
    self.name = name
    self.image = image
    self.emailVerified = emailVerified
    self.data = data
  }
}
