import Foundation

extension URL {
  func getHost() throws -> URL {
    guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
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
}
