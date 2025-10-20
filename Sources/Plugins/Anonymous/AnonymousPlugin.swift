import BetterAuth
import Foundation

public final class AnonymousPlugin: PluginFactory {
  public static let id: String = "anonymous"
  public static func create(client: BetterAuthClient) -> Pluggable {
    Anonymous(client: client)
  }

  public init() {}
}

@MainActor
public final class Anonymous: Pluggable {
  private weak var client: BetterAuthClient?

  public init(client: BetterAuthClient) {
    self.client = client
  }
}
