internal enum UsernamePluginData {
  case username
  case displayUsername
  
  var pluginFieldName: String {
    switch self {
    case .username:
      "username"
    case .displayUsername:
      "displayUsername"
    }
  }
}
