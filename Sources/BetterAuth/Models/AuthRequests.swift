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
}

public struct SignOutResponse: Codable, Sendable {
  public let success: Bool
}

public struct ForgetPasswordRequest: Codable, Sendable {
  public let email: String
  public let redirectTo: String?
}

public struct ForgetPasswordResponse: Codable, Sendable {
  public let status: Bool
  public let message: String
}

public struct ResetPasswordRequest: Codable, Sendable {
  public let token: String?
  public let newPassword: String
}

public struct ResetPasswordResponse: Codable, Sendable {
  public let status: Bool
}

public struct VerifyEmailRequest: Codable, Sendable {
  public let token: String
  public let callbackURL: String?
}

public struct VerifyEmailResponse: Codable, Sendable {
  public let user: User
  public let status: Bool
}

public struct SendVerificationEmailRequest: Codable, Sendable {
  public let email: String
  public let callbackURL: String?
}

public struct SendVerificationEmailResponse: Codable, Sendable {
  public let status: Bool
}

public struct ChangeEmailRequest: Codable, Sendable {
  public let newEmail: String
  public let callbackURL: String?
}

public struct ChangeEmailResponse: Codable, Sendable {
  public let status: Bool
  public let message: String
}

public struct ChangePasswordRequest: Codable, Sendable {
  public let currentPassword: String
  public let newPassword: String
  public let revokeOtherSessions: Bool?
}

public struct ChangePasswordResponse: Codable, Sendable {
  public let token: String?
  public let user: User
}

public struct UpdateUserRequest: Codable, Sendable {
  public let image: String?
  public let name: String?
}

public struct UpdateUserResponse: Codable, Sendable {
  public let status: Bool
}

public struct DeleteUserRequest: Codable, Sendable {
  public let token: String?
  public let password: String?
  public let callbackURL: String?
}

public struct DeleteUserResponse: Codable, Sendable {
  public let success: Bool
  public let message: String
}

public struct RequestPasswordResetRequest: Codable, Sendable {
  public let email: String
  public let redirectTo: String?
}

public struct RequestPasswordResetResponse: Codable, Sendable {
  public let status: Bool
  public let message: String
}

public typealias ListSessionResponse = [SessionData]

public struct RevokeSessionRequest: Codable, Sendable {
  public let token: String
}

public struct RevokeSessionResponse: Codable, Sendable {
  public let status: Bool
}

public struct RevokeSessionsResponse: Codable, Sendable {
  public let status: Bool
}

public struct RevokeOtherSessionsResponse: Codable, Sendable {
  public let status: Bool
}

public struct LinkSocialRequest: Codable, Sendable {
  public let provider: String
  public let callbackURL: String?
  public let disableRedirect: Bool?
  public let errorCallbackURL: String?
  public let idToken: String?
  public let requestSignUp: Bool?
  public let scopes: [String]?
}

public struct LinkSocialResponse: Codable, Sendable {
  public let url: String?
  public let redirect: Bool
  public let status: Bool?
}

public struct Account: Codable, Sendable {
  public let id: String
  public let provider: String
  public let createdAt: Date
  public let updatedAt: Date
}

public typealias ListAccountsResponse = [Account]

public struct UnlinkAccountRequest: Codable, Sendable {
  public let providerId: String
  public let accountId: String?
}

public struct UnlinkAccountResponse: Codable, Sendable {
  public let status: Bool
}

public struct RefreshTokenRequest: Codable, Sendable {
  public let providerId: String
  public let accountId: String?
  public let userId: String?
}

public struct RefreshTokenResponse: Codable, Sendable {
  public let tokenType: String
  public let idToken: String
  public let accessToken: String
  public let refreshToken: String
  public let accessTokenExpiresAt: Date
  public let refreshTokenExpiresAt: Date
}

public struct GetAccessTokenRequest: Codable, Sendable {
  public let providerId: String
  public let accountId: String?
  public let userId: String?
}

public struct GetAccessTokenResponse: Codable, Sendable {
  public let tokenType: String
  public let idToken: String
  public let accessToken: String
  public let refreshToken: String
  public let accessTokenExpiresAt: Date
  public let refreshTokenExpiresAt: Date
}

public struct AccountInfoRequest: Codable, Sendable {
  public let accountId: String
}

public struct AccountInfoResponse: Codable, Sendable {
  public let id: String
  public let email: String
  public let name: String
  public let image: String
  public let emailVerified: Bool
  public let data: [String: String]
}
