import BetterAuth
import Foundation

extension SessionUser {
  public var twoFactorEnabled: Bool? {
    return pluginData?[TwoFactorPluginData.twoFactorEnabled.pluginFieldName]?
      .value as? Bool
  }
}
