import BetterAuth
import Foundation

public final class MagicLinkPlugin: PluginFactory {  
  public static let id: String = "magicLink"
  public static func create(client: BetterAuthClient) -> Pluggable {
    MagicLink()
  }
  
  public init() {}
}

public final class MagicLink: Pluggable {}
