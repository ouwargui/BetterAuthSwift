import Foundation

public struct Session: Codable, Sendable {
  public let session: SessionData
  public let user: User
}

public struct SessionData: Codable, Sendable {
  public let id: String
  public let userId: String
  public let expiresAt: Date
  public let createdAt: Date
  public let updatedAt: Date
}

public struct User: Codable, Sendable {
  public let id: String
  public let email: String
  public let name: String?
  public let image: String?
  public let emailVerified: Bool
  public let createdAt: Date
  public let updatedAt: Date
}
