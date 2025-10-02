import BetterAuth

internal enum TwoFactorPluginData {
  case twoFactorEnabled

  var pluginFieldName: String {
    switch self {
    case .twoFactorEnabled:
      "twoFactorEnabled"
    }
  }
}

extension BetterAuthContext {
  public var twoFactorEnabled: Bool? {
    self.meta[TwoFactorPluginData.twoFactorEnabled.pluginFieldName]?.value
      as? Bool
  }
}
