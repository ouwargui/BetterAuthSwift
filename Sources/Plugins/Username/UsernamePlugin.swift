import BetterAuth
import Foundation

public final class UsernamePlugin: PluginFactory {
  public static let id: String = "username"
  public static func create(client: BetterAuthClient) -> Pluggable {
    Username(client: client)
  }

  public init() {}
}

@MainActor
public final class Username: Pluggable {
  private weak var client: BetterAuthClient?

  public init(client: BetterAuthClient) {
    self.client = client
  }
}
