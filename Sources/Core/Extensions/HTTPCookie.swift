import Foundation

extension HTTPCookie {
  static func cookies(fromCombinedHeader header: String, for url: URL)
    -> [HTTPCookie]
  {
    let parts = splitSetCookieHeader(header)
    var cookies: [HTTPCookie] = []

    for raw in parts {
      // Sometimes a cookie starts with '+' or ',' which shouldn’t be there
      let cookieStr = raw.trimmingCharacters(in: .whitespaces)
        .trimmingCharacters(in: CharacterSet(charactersIn: "+,"))

      guard !cookieStr.isEmpty else { continue }

      let segments =
        cookieStr
        .split(separator: ";", omittingEmptySubsequences: false)
        .map { $0.trimmingCharacters(in: .whitespaces) }

      guard let nameValue = segments.first else { continue }

      let pair = nameValue.split(separator: "=", maxSplits: 1).map(String.init)
      guard let name = pair.first else { continue }
      let value = pair.dropFirst().joined(separator: "=")

      var attributes: [String: String] = [:]
      for attr in segments.dropFirst() {
        let attrPair = attr.split(separator: "=", maxSplits: 1).map(String.init)
        guard let key = attrPair.first else { continue }
        attributes[key.lowercased()] = attrPair.count > 1 ? attrPair[1] : ""
      }

      var props: [HTTPCookiePropertyKey: Any] = [
        .name: name,
        .value: value,
        .domain: url.host ?? "",
        .path: attributes["path"] ?? "/",
      ]

      if let maxAge = attributes["max-age"], let seconds = Int(maxAge) {
        props[.expires] = Date(timeIntervalSinceNow: TimeInterval(seconds))
      }

      if attributes.keys.contains("secure") {
        props[.secure] = true
      }
      if attributes.keys.contains("httponly") {
        props[.init("HttpOnly")] = true
      }
      if let sameSite = attributes["samesite"] {
        props[.sameSitePolicy] = sameSite.capitalized
      }

      if let cookie = HTTPCookie(properties: props) {
        cookies.append(cookie)
      }
    }

    return cookies
  }
}

private func splitSetCookieHeader(_ header: String) -> [String] {
  var parts: [String] = []
  var buffer = ""
  var i = header.startIndex

  while i < header.endIndex {
    let char = header[i]
    if char == "," {
      let recent = buffer.lowercased()
      let hasExpires = recent.contains("expires=")
      let hasGMT = recent.range(of: "gmt", options: .caseInsensitive) != nil
      if hasExpires && !hasGMT {
        buffer.append(char)
        i = header.index(after: i)
        continue
      }

      if !buffer.trimmingCharacters(in: .whitespaces).isEmpty {
        parts.append(buffer.trimmingCharacters(in: .whitespaces))
        buffer = ""
      }

      i = header.index(after: i)
      if i < header.endIndex, header[i] == " " {
        i = header.index(after: i)
      }
      continue
    }

    buffer.append(char)
    i = header.index(after: i)
  }

  if !buffer.trimmingCharacters(in: .whitespaces).isEmpty {
    parts.append(buffer.trimmingCharacters(in: .whitespaces))
  }

  return parts
}
