import Foundation
import Security

class KeychainStorage {
  private let service: String

  init(service: String = "BetterAuth") {
    self.service = service
  }

  func save(key: String, value: String) throws {
    let data = value.data(using: .utf8)!

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecValueData as String: data
    ]

    SecItemDelete(query as CFDictionary)

    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw BetterAuthError(
        code: nil,
        message: "Failed to save to keychain",
        status: nil,
        statusText: nil
      )
    }
  }

  func get(key: String) -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess,
      let data = result as? Data,
      let value = String(data: data, encoding: .utf8) else {
    return nil
    }

    return value
  }

  func delete(key: String) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key
    ]

    SecItemDelete(query as CFDictionary)
  }
}
