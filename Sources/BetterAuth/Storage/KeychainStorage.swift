import Foundation
import Security

class KeychainStorage {
  private let service: String
  private let accessGroup: String?

  public init(service: String = "BetterAuth", accessGroup: String? = nil) {
    self.service = service
    self.accessGroup = accessGroup
  }

  @discardableResult
  public func save(key: String, value: String) throws -> Bool {
    let data = value.data(using: .utf8) ?? Data()
    return try save(key: key, data: data)
  }

  @discardableResult
  public func save(key: String, data: Data) throws -> Bool {
    delete(key: key)

    let query = buildQuery(for: key)
    var queryWithData = query
    queryWithData[kSecValueData as String] = data

    #if !targetEnvironment(simulator)
      queryWithData[kSecAttrAccessible as String] =
        kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    #endif

    let status = SecItemAdd(queryWithData as CFDictionary, nil)

    guard status == errSecSuccess else {
      throw KeychainError.saveError(status)
    }

    return true
  }

  public func get(key: String) -> String? {
    guard let data = getData(key: key) else { return nil }
    return String(data: data, encoding: .utf8)
  }

  public func getData(key: String) -> Data? {
    var query = buildQuery(for: key)
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnData as String] = true

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess else {
      if status != errSecItemNotFound {
        print("Keychain read error: \(status)")
      }
      return nil
    }

    return result as? Data
  }

  @discardableResult
  public func delete(key: String) -> Bool {
    let query = buildQuery(for: key)
    let status = SecItemDelete(query as CFDictionary)

    return status == errSecSuccess || status == errSecItemNotFound
  }

  public func deleteAll() throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
    ]

    let status = SecItemDelete(query as CFDictionary)

    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.deleteError(status)
    }
  }

  private func buildQuery(for key: String) -> [String: Any] {
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
    ]

    #if !targetEnvironment(simulator)
      if let accessGroup = accessGroup {
        query[kSecAttrAccessGroup as String] = accessGroup
      }
    #endif

    return query
  }
}

enum KeychainError: Error, LocalizedError {
  case saveError(OSStatus)
  case deleteError(OSStatus)
  case unexpectedError(OSStatus)

  public var errorDescription: String? {
    switch self {
    case .saveError(let status):
      return
        "Failed to save to keychain: \(status) (\(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString))"
    case .deleteError(let status):
      return
        "Failed to delete from keychain: \(status) (\(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString))"
    case .unexpectedError(let status):
      return
        "Unexpected keychain error: \(status) (\(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString))"
    }
  }
}

extension KeychainStorage {
  public func save<T: Codable>(key: String, object: T) throws {
    let data = try JSONEncoder().encode(object)
    try save(key: key, data: data)
  }

  public func getObject<T: Codable>(key: String, type: T.Type) -> T? {
    guard let data = getData(key: key) else { return nil }
    return try? JSONDecoder().decode(type, from: data)
  }

  public func exists(key: String) -> Bool {
    return getData(key: key) != nil
  }

  public func getAllKeys() -> [String] {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecMatchLimit as String: kSecMatchLimitAll,
      kSecReturnAttributes as String: true,
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess,
      let items = result as? [[String: Any]]
    else {
      return []
    }

    return items.compactMap { item in
      item[kSecAttrAccount as String] as? String
    }
  }
}

#if DEBUG
  extension KeychainStorage {
    public func printAllItems() {
      let keys = getAllKeys()
      print("=== Keychain Items for service '\(service)' ===")

      if keys.isEmpty {
        print("No items found")
      } else {
        for key in keys {
          let value = get(key: key) ?? "[Data]"
          print("\(key): \(value)")
        }
      }
      print("=== End Keychain Items ===")
    }
  }
#endif
