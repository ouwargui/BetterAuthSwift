import Foundation

public struct BetterAuthContext<C: Codable & Sendable>: Codable, Sendable {
  package let meta: [String: AnyCodable]

  package init(meta: [String: AnyCodable] = [:]) {
    self.meta = meta
  }
}

// MARK: Phantom types
public struct EmptyContext: Codable, Sendable {}

public struct SignInContext: Codable, Sendable {}
