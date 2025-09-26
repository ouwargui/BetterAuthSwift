import Foundation

extension Encodable {
  func toQueryItems() -> [URLQueryItem] {
    guard let data = try? JSONEncoder().encode(self),
          let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      return []
    }
    
    return dictionary.compactMap { key, value in
      guard !(value is NSNull) else { return nil }
      
      let stringValue: String
      
      switch value {
      case let string as String:
        stringValue = string
      case let number as NSNumber:
        stringValue = number.stringValue
      case let bool as Bool:
        stringValue = bool ? "true" : "false"
      case let array as [Any]:
        stringValue = array.map { "\($0)" }.joined(separator: "/")
      default:
        stringValue = "\(value)"
      }
      
      return URLQueryItem(name: key, value: stringValue)
    }
  }
}
