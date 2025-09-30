import Foundation

public protocol AuthRoutable: Sendable {
  var path: String { get }
  var method: String { get }
}

public enum BetterAuthRoute: AuthRoutable {
  case signUpEmail
  case signInEmail
  case signInSocial
  case signOut
  case getSession
  case forgetPassword
  case resetPassword
  case verifyEmail
  case sendVerificationEmail
  case changeEmail
  case changePassword
  case updateUser
  case deleteUser
  case requestPasswordReset
  case listSessions
  case revokeSession
  case revokeSessions
  case revokeOtherSessions
  case linkSocial
  case listAccounts
  case deleteUserCallback
  case unlinkAccount
  case refreshToken
  case getAccessToken
  case accountInfo

  public var path: String {
    switch self {
    case .getSession:
      return "/get-session"
    case .signInSocial:
      return "/sign-in/social"
    case .signInEmail:
      return "/sign-in/email"
    case .signUpEmail:
      return "/sign-up/email"
    case .signOut:
      return "/sign-out"
    case .forgetPassword:
      return "/forget-password"
    case .resetPassword:
      return "/reset-password"
    case .verifyEmail:
      return "/verify-email"
    case .sendVerificationEmail:
      return "/send-verification-email"
    case .changeEmail:
      return "/change-email"
    case .changePassword:
      return "/change-password"
    case .updateUser:
      return "/update-user"
    case .deleteUser:
      return "/delete-user"
    case .requestPasswordReset:
      return "/request-password-reset"
    case .listSessions:
      return "/list-sessions"
    case .revokeSession:
      return "/revoke-session"
    case .revokeSessions:
      return "/revoke-sessions"
    case .revokeOtherSessions:
      return "/revoke-other-sessions"
    case .linkSocial:
      return "/link-social"
    case .listAccounts:
      return "/list-accounts"
    case .deleteUserCallback:
      return "/delete-user/callback"
    case .unlinkAccount:
      return "/unlink-account"
    case .refreshToken:
      return "/refresh-token"
    case .getAccessToken:
      return "/get-access-token"
    case .accountInfo:
      return "/account-info"
    }
  }

  public var method: String {
    switch self {
    case .signInEmail, .signUpEmail, .signOut, .signInSocial, .forgetPassword,
      .sendVerificationEmail, .changeEmail, .changePassword, .updateUser,
      .deleteUser, .requestPasswordReset, .revokeSession, .revokeSessions,
      .revokeOtherSessions, .linkSocial, .unlinkAccount, .refreshToken,
      .getAccessToken, .accountInfo, .resetPassword:
      return "POST"
    case .getSession, .verifyEmail, .listSessions,
      .listAccounts, .deleteUserCallback:
      return "GET"
    }
  }
}
