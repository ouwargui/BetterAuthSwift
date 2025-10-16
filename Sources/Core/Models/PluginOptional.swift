import Foundation

public struct PluginOptional<Wrapped: Codable & Sendable>: Codable, Sendable {
  public let value: Wrapped?

  public init(from decoder: Decoder) throws {
    let single = try decoder.singleValueContainer()
    do { self.value = try single.decode(Wrapped.self) } catch {
      self.value = nil
    }
  }

  public func encode(to encoder: Encoder) throws {
    var single = encoder.singleValueContainer()
    do { try single.encode(self.value) } catch { try single.encodeNil() }
  }
}
