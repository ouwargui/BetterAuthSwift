import Foundation
import BetterAuth

extension User {
  public var twoFactorEnabled: Bool? {
    return pluginData?["twoFactorEnabled"]?.value as? Bool
  }
}
