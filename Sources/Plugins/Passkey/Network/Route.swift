import BetterAuth
import Foundation

public enum BetterAuthPasskeyRoute: AuthRoutable {
  case passkeyGenerateRegisterOptions
  case passkeyGenerateAuthenticateOptions
  case passkeyVerifyRegistration
  case passkeyVerifyAuthentication
  case passkeyListUserPasskeys
  case passkeyDeletePasskey
  case passkeyUpdatePasskey

  public var path: String {
    switch self {
    case .passkeyGenerateRegisterOptions:
      "/passkey/generate-register-options"
    case .passkeyGenerateAuthenticateOptions:
      "/passkey/generate-authenticate-options"
    case .passkeyVerifyRegistration:
      "/passkey/verify-registration"
    case .passkeyVerifyAuthentication:
      "/passkey/verify-authentication"
    case .passkeyListUserPasskeys:
      "/passkey/list-user-passkeys"
    case .passkeyDeletePasskey:
      "/passkey/delete-passkey"
    case .passkeyUpdatePasskey:
      "/passkey/update-passkey"
    }
  }

  public var method: String {
    switch self {
    case .passkeyGenerateRegisterOptions, .passkeyListUserPasskeys:
      "GET"
    case .passkeyGenerateAuthenticateOptions, .passkeyVerifyRegistration,
      .passkeyVerifyAuthentication, .passkeyDeletePasskey,
      .passkeyUpdatePasskey:
      "POST"
    }
  }
}
