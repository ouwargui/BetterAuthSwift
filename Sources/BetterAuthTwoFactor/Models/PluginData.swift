import BetterAuth

internal enum TwoFactorPluginData {
  case twoFactorEnabled
  case twoFactorRedirect

  var pluginFieldName: String {
    switch self {
    case .twoFactorEnabled:
      "twoFactorEnabled"
    case .twoFactorRedirect:
      "twoFactorRedirect"
    }
  }
}
