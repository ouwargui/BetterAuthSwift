import BetterAuth

public enum BetterAuthTwoFactorRoute: AuthRoutable {
  case enable
  case disable
  case generateBackupCodes
  case getTotpURI
  case sendOTP
  case verifyBackupCode
  case verifyOTP
  case verifyTOTP

  public var path: String {
    switch self {
    case .enable:
      "/two-factor/enable"
    case .disable:
      "/two-factor/disable"
    case .generateBackupCodes:
      "/two-factor/generate-backup-codes"
    case .getTotpURI:
      "/two-factor/get-totp-uri"
    case .sendOTP:
      "/two-factor/send-otp"
    case .verifyBackupCode:
      "/two-factor/verify-backup-code"
    case .verifyOTP:
      "/two-factor/verify-otp"
    case .verifyTOTP:
      "/two-factor/verify-totp"
    }
  }

  public var method: String {
    switch self {
    case .enable, .disable, .generateBackupCodes, .getTotpURI,
      .sendOTP, .verifyBackupCode, .verifyOTP, .verifyTOTP:
      "POST"
    }
  }
}
