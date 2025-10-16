import BetterAuth
import Foundation

public final class PhoneNumberPlugin: PluginFactory {
  public static let id: String = "phoneNumber"
  public static func create(client: BetterAuthClient) -> Pluggable {
    PhoneNumber()
  }
  
  public init() {}
}

public final class PhoneNumber: Pluggable {}
