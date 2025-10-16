import Foundation

extension Data {
  package init?(base64urlEncoded input: String) {
    var base64 = input
    base64 = base64.replacingOccurrences(of: "-", with: "+")
    base64 = base64.replacingOccurrences(of: "_", with: "/")
    while base64.count % 4 != 0 {
      base64 = base64.appending("=")
    }
    self.init(base64Encoded: base64)
  }

  package func base64urlEncodedString() -> String {
    var result = self.base64EncodedString()
    result = result.replacingOccurrences(of: "+", with: "-")
    result = result.replacingOccurrences(of: "/", with: "_")
    result = result.replacingOccurrences(of: "=", with: "")
    return result
  }

  package var json: NSString? {
    guard
      let jsonObject = try? JSONSerialization.jsonObject(
        with: self,
        options: []
      ),
      let data = try? JSONSerialization.data(
        withJSONObject: jsonObject,
        options: .prettyPrinted
      ),
      let prettyJson = NSString(
        data: data,
        encoding: String.Encoding.utf8.rawValue
      )
    else {
      return nil
    }

    return prettyJson
  }
}
