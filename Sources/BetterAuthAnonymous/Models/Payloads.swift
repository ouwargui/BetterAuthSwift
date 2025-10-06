import BetterAuth
import Foundation

public struct AnonymousSignInAnonymousResponse: Codable, Sendable {
  public let user: User
  public let token: String

  public init(user: User, token: String) {
    self.user = user
    self.token = token
  }
}
