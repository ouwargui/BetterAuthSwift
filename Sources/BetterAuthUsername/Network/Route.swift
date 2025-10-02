import BetterAuth

public enum BetterAuthUsernameRoute: AuthRoutable {
  case signInUsername
  case isUsernameAvailable

  public var path: String {
    switch self {
    case .signInUsername:
      "/sign-in/username"
    case .isUsernameAvailable:
      "/is-username-available"
    }
  }

  public var method: String {
    switch self {
    case .signInUsername, .isUsernameAvailable:
      "POST"
    }
  }
}
