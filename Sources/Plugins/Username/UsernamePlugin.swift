import Foundation
import BetterAuth

public final class UsernamePlugin: PluginFactory {
  public static let id: String = "username"
  public static func create(client: BetterAuthClient) -> Pluggable {
    Username()
  }
  
  public init() {}
}

@MainActor
public class Username: Pluggable {}
