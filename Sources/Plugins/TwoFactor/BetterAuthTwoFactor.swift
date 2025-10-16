import BetterAuth
import Foundation

extension BetterAuthClient {
  public var twoFactor: TwoFactor {
    self.pluginRegistry.get(id: TwoFactorPlugin.id)
  }
}
