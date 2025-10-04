import BetterAuth

extension SessionUser {
  public var username: String? {
    return pluginData[UsernamePluginData.username.pluginFieldName]?.value
      as? String
  }

  public var displayUsername: String? {
    return pluginData[UsernamePluginData.displayUsername.pluginFieldName]?
      .value as? String
  }
}
