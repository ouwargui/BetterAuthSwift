import Foundation

extension Data {
  var json: NSString? {
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
