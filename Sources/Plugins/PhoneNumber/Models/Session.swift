import BetterAuth
import Foundation

extension SessionUser {
  public var phoneNumber: String? {
    return pluginData[PhoneNumberPluginData.phoneNumber.pluginFieldName]?
      .value as? String
  }

  public var phoneNumberVerified: Bool? {
    return pluginData[
      PhoneNumberPluginData.phoneNumberVerified.pluginFieldName
    ]?
    .value as? Bool
  }
}
