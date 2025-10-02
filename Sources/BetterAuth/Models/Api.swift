import Foundation

public struct BetterAuthContext: Codable, Sendable {
  package let meta: [String: AnyCodable]
  
  package init(meta: [String : AnyCodable]) {
    self.meta = meta
  }
}

public struct APIResource<T: Codable & Sendable>: Codable, Sendable {
  public let data: T
  public let context: BetterAuthContext

  init(data: T, context: BetterAuthContext) {
    self.data = data
    self.context = context
  }

  public init(from decoder: Decoder) throws {
    self.data = try T(from: decoder)

    let encoder = JSONEncoder()
    let tData = try encoder.encode(self.data)
    let tDict =
      try JSONSerialization.jsonObject(with: tData) as? [String: Any] ?? [:]
    let tKeys = Set(tDict.keys)

    let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
    var metadata: [String: AnyCodable] = [:]

    for key in container.allKeys {
      if !tKeys.contains(key.stringValue) {
        let value = try container.decode(AnyCodable.self, forKey: key)
        metadata[key.stringValue] = value
      }
    }

    self.context = .init(meta: metadata)
  }

  public func encode(to encoder: Encoder) throws {
    try data.encode(to: encoder)

    if !self.context.meta.isEmpty {
      var container = encoder.container(keyedBy: DynamicCodingKeys.self)
      for (key, value) in self.context.meta {
        let codingKey = DynamicCodingKeys(stringValue: key)!
        try container.encode(value, forKey: codingKey)
      }
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
