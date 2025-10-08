import Foundation
import OSLog

public struct APIResource<T: Codable & Sendable, C: Codable & Sendable>:
  Codable, Sendable
{
  public let data: T
  public let context: BetterAuthContext<C>
  private let logger = Logger(
    subsystem: "com.betterauth",
    category: "APIResource"
  )

  package init(data: T, context: BetterAuthContext<C>) {
    self.data = data
    self.context = context
  }

  public init(from decoder: Decoder) throws {
    self.data = try T(from: decoder)
    var metadata: [String: AnyCodable] = [:]

    do {
      let encoder = JSONEncoder()
      let tData = try encoder.encode(self.data)

      let tKeys: Set<String>
      if let dict = try? JSONDecoder().decode(
        [String: AnyCodable].self,
        from: tData
      ) {
        tKeys = Set(dict.keys)
      } else {
        tKeys = []
      }

      let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
      for key in container.allKeys where !tKeys.contains(key.stringValue) {
        let value = try container.decode(AnyCodable.self, forKey: key)
        metadata[key.stringValue] = value
      }
    } catch {
      logger.debug("Failed to decode metadata: \(error)")
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

extension APIResource {
  package init<U: Codable & Sendable>(
    from source: APIResource<PluginOptional<U>, C>
  ) where T == U? {
    self.init(data: source.data.value, context: source.context)
  }
}
