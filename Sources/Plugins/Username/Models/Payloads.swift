import BetterAuth
import Foundation

public struct UsernameSignUpEmailRequest: Codable, Sendable {
  public let email: String
  public let password: String
  public let name: String
  public let image: String?
  public let callbackURL: String?
  public let rememberMe: Bool?
  public let username: String
  public let displayUsername: String?

  public init(
    email: String,
    password: String,
    name: String,
    image: String? = nil,
    callbackURL: String? = nil,
    rememberMe: Bool? = nil,
    username: String,
    displayUsername: String? = nil
  ) {
    self.email = email
    self.password = password
    self.name = name
    self.image = image
    self.callbackURL = callbackURL
    self.rememberMe = rememberMe
    self.username = username
    self.displayUsername = displayUsername
  }
}

public struct UsernameSignInUsernameRequest: Codable, Sendable {
  public let username: String
  public let password: String
  public let callbackURL: String?
  public let rememberMe: Bool?

  public init(
    username: String,
    password: String,
    callbackURL: String? = nil,
    rememberMe: Bool? = nil
  ) {
    self.username = username
    self.password = password
    self.callbackURL = callbackURL
    self.rememberMe = rememberMe
  }
}

public struct UserWithUsername: UserProtocol {
  public let id: String
  public let email: String
  public let name: String
  public let image: String?
  public let emailVerified: Bool
  public let createdAt: Date
  public let updatedAt: Date
  public let username: String

  public init(
    id: String,
    email: String,
    name: String,
    image: String? = nil,
    emailVerified: Bool,
    createdAt: Date,
    updatedAt: Date,
    username: String
  ) {
    self.id = id
    self.email = email
    self.name = name
    self.image = image
    self.emailVerified = emailVerified
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.username = username
  }
}

public struct UsernameSignInUsernameResponse: Codable, Sendable {
  public let user: UserWithUsername
  public let token: String

  public init(user: UserWithUsername, token: String) {
    self.user = user
    self.token = token
  }
}

public struct UsernameIsUsernameAvailableRequest: Codable, Sendable {
  public let username: String

  public init(username: String) {
    self.username = username
  }
}

public struct UsernameIsUsernameAvailableResponse: Codable, Sendable {
  public let available: Bool

  public init(available: Bool) {
    self.available = available
  }
}
