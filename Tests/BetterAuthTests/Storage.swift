import Foundation
import BetterAuth

final class InMemoryStorage: StorageProtocol {
  private var store: [String: String] = [:]

  func get(key: String) -> String? {
    return store[key]
  }

  @discardableResult
  func save(key: String, value: String) throws -> Bool {
    store[key] = value
    return true
  }
}
