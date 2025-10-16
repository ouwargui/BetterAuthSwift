import BetterAuth
import Foundation

public final class EmailOTPPlugin: PluginFactory {
  public static let id: String = "email-otp"
  public static func create(client: BetterAuthClient) -> Pluggable {
    EmailOTP()
  }
  
  public init() {}
}

public final class EmailOTP: Pluggable {}
