import BetterAuth
import Foundation

public enum BetterAuthMagicLinkRoute: AuthRoutable {
  case signInMagicLink
  case magicLinkVerify

  public var path: String {
    switch self {
    case .signInMagicLink:
      "/sign-in/magic-link"
    case .magicLinkVerify:
      "/magic-link/verify"
    }
  }

  public var method: String {
    switch self {
    case .signInMagicLink:
      "POST"
    case .magicLinkVerify:
      "GET"
    }
  }
}
