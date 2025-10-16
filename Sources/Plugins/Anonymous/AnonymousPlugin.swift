import BetterAuth
import Foundation

public final class AnonymousPlugin: PluginFactory {
  public static let id: String = "anonymous"
  public static func create(client: BetterAuthClient) -> Pluggable {
    Anonymous()
  }
  
  public init() {}
}

public final class Anonymous: Pluggable {}
