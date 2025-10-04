import Foundation

public struct Session: Codable, Sendable, Loggable {
  public let session: SessionData
  public let user: SessionUser

  public init(session: SessionData, user: SessionUser) {
    self.session = session
    self.user = user
  }
}

public struct SessionData: Codable, Sendable, Loggable {
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

package protocol UserProtocol: Codable, Sendable, Loggable {
  var id: String { get }
  var email: String { get }
  var name: String { get }
  var image: String? { get }
  var emailVerified: Bool { get }
  var createdAt: Date { get }
  var updatedAt: Date { get }
}

public struct User: UserProtocol {
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
    updatedAt: Date,
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

public struct SessionUser: UserProtocol {
  public let id: String
  public let email: String
  public let name: String
  public let image: String?
  public let emailVerified: Bool
  public let createdAt: Date
  public let updatedAt: Date
  package let pluginData: [String: AnyCodable]

  package init(
    id: String,
    email: String,
    name: String,
    image: String?,
    emailVerified: Bool,
    createdAt: Date,
    updatedAt: Date,
    pluginData: [String: AnyCodable] = [:]
  ) {
    self.id = id
    self.email = email
    self.name = name
    self.image = image
    self.emailVerified = emailVerified
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.pluginData = pluginData
  }

  internal init(_ user: UserProtocol, metadata: [String: AnyCodable] = [:]) {
    self.init(
      id: user.id,
      email: user.email,
      name: user.name,
      image: user.image,
      emailVerified: user.emailVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      pluginData: metadata
    )
  }

  private enum CodingKeys: String, CodingKey, CaseIterable {
    case id, email, name, image, emailVerified, createdAt, updatedAt
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decode(String.self, forKey: .id)
    email = try container.decode(String.self, forKey: .email)
    name = try container.decode(String.self, forKey: .name)
    image = try container.decodeIfPresent(String.self, forKey: .image)
    emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
    createdAt = try container.decode(Date.self, forKey: .createdAt)
    updatedAt = try container.decode(Date.self, forKey: .updatedAt)

    let dynamicContainer = try decoder.container(
      keyedBy: DynamicCodingKeys.self
    )
    var unknownFields: [String: AnyCodable] = [:]

    let knownKeys = Set(CodingKeys.allCases.map { $0.rawValue })

    for key in dynamicContainer.allKeys {
      if !knownKeys.contains(key.stringValue) {
        let value = try dynamicContainer.decode(AnyCodable.self, forKey: key)
        unknownFields[key.stringValue] = value
      }
    }

    pluginData = unknownFields.isEmpty ? [:] : unknownFields
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(email, forKey: .email)
    try container.encode(name, forKey: .name)
    try container.encodeIfPresent(image, forKey: .image)
    try container.encode(emailVerified, forKey: .emailVerified)
    try container.encode(createdAt, forKey: .createdAt)
    try container.encode(updatedAt, forKey: .updatedAt)

    var dynamicContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
    for (key, value) in pluginData {
      let codingKey = DynamicCodingKeys(stringValue: key)!
      try dynamicContainer.encode(value, forKey: codingKey)
    }
  }

  private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
      self.stringValue = stringValue
      self.intValue = nil
    }

    init?(intValue: Int) {
      self.stringValue = String(intValue)
      self.intValue = intValue
    }
  }
}
