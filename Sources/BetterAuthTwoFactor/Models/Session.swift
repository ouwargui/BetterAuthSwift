import BetterAuth
import Foundation

extension User {
  public var twoFactorEnabled: Bool? {
    return pluginData?["twoFactorEnabled"]?.value as? Bool
  }
}
