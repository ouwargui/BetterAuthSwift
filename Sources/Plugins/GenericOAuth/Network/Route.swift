import BetterAuth
import Foundation

public enum BetterAuthGenericOAuthRoute: AuthRoutable {
  case signInOAuth2
  case oauth2Link

  public var path: String {
    switch self {
    case .signInOAuth2:
      return "/sign-in/oauth2"
    case .oauth2Link:
      return "/oauth2/link"
    }
  }

  public var method: String {
    switch self {
    case .signInOAuth2, .oauth2Link:
      return "POST"
    }
  }
}
