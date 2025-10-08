import Foundation

public protocol Loggable: CustomStringConvertible {
  var description: String { get }
}

extension Loggable where Self: Codable {
  public var description: String {
    do {
      let data = try JSONEncoder().encode(self)
      let json = try JSONSerialization.jsonObject(with: data)
      let prettyJson = try JSONSerialization.data(
        withJSONObject: json,
        options: .prettyPrinted
      )
      guard
        let string = NSString(
          data: prettyJson,
          encoding: String.Encoding.utf8.rawValue
        )
      else {
        return ""
      }

      return string as String
    } catch {
      return ""
    }
  }
}
