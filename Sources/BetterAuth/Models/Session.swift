import Foundation

public struct Session: Codable, Sendable {
  public let session: SessionData
  public let user: User

  public init(session: SessionData, user: User) {
    self.session = session
    self.user = user
  }
}

public struct SessionData: Codable, Sendable {
  public let id: String
  public let userId: String
  public let token: String
  public let ipAddress: String
  public let userAgent: String
  public let expiresAt: Date
  public let createdAt: Date
  public let updatedAt: Date

  public init(
    id: String,
    userId: String,
    token: String,
    ipAddress: String,
    userAgent: String,
    expiresAt: Date,
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.userId = userId
    self.token = token
    self.ipAddress = ipAddress
    self.userAgent = userAgent
    self.expiresAt = expiresAt
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

public struct User: Codable, Sendable {
  public let id: String
  public let email: String
  public let name: String
  public let image: String?
  public let emailVerified: Bool
  public let createdAt: Date
  public let updatedAt: Date

  public init(
    id: String,
    email: String,
    name: String,
    image: String?,
    emailVerified: Bool,
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.email = email
    self.name = name
    self.image = image
    self.emailVerified = emailVerified
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
