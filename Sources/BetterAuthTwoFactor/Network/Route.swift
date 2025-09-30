import BetterAuth

public enum BetterAuthTwoFactorRoute: AuthRoutable {
  case twoFactorEnable
  case twoFactorDisable
  
  public var path: String {
    switch self {
    case .twoFactorEnable:
      "/two-factor/enable"
    case .twoFactorDisable:
      "/two-factor/disable"
    }
  }
  
  public var triggerSessionRefresh: Bool {
    switch self {
    case .twoFactorEnable, .twoFactorDisable:
      false
    }
  }
  
  public var method: String {
    switch self {
    case .twoFactorEnable, .twoFactorDisable:
        "POST"
    }
  }
}
