import Foundation

extension URL {
  func getHost() throws -> URL {
    guard
      var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
    else {
      throw BetterAuthSwiftError(message: "Failed to parse baseURL")
    }

    components.path = ""
    components.query = nil
    components.fragment = nil

    guard let hostURL = components.url else {
      throw BetterAuthSwiftError(message: "Failed to construct host URL")
    }

    return hostURL
  }

  func getBaseURL() -> URL {
    if #available(iOS 16.0, macOS 13.0, *) {
      if self.path().isEmpty || self.path() == "/" {
        return self.appending(path: "/api/auth")
      }
    } else {
      if self.path.isEmpty || self.path == "/" {
        return self.appendingPathComponent("/api/auth")
      }
    }

    return self
  }
}
