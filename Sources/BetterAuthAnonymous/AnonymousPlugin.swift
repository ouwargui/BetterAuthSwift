import BetterAuth
import Foundation

public struct AnonymousPlugin: AuthPlugin {
  public let id: String = "anonymous"

  public init() {}
}
