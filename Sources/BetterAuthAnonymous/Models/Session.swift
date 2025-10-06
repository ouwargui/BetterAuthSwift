import BetterAuth
import Foundation

extension SessionUser {
  public var isAnonymous: Bool? {
    return pluginData[AnonymousPluginData.isAnonymous.pluginFieldName]?
      .value as? Bool
  }
}
