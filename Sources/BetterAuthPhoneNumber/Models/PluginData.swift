import BetterAuth

internal enum PhoneNumberPluginData {
  case phoneNumber
  case phoneNumberVerified

  var pluginFieldName: String {
    switch self {
    case .phoneNumber:
      "phoneNumber"
    case .phoneNumberVerified:
      "phoneNumberVerified"
    }
  }
}
