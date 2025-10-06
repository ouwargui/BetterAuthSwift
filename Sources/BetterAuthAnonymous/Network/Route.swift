import BetterAuth
import Foundation

public enum BetterAuthAnonymousRoute: AuthRoutable {
  case signInAnonymous

  public var path: String {
    switch self {
    case .signInAnonymous:
      "/sign-in/anonymous"
    }
  }

  public var method: String {
    switch self {
    case .signInAnonymous:
      "POST"
    }
  }
}
