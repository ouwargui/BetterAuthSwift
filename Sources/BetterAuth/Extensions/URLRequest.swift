import Foundation

extension URLRequest {
  mutating func addQueryItems(_ queryItems: [URLQueryItem]) {
    guard let url = self.url,
          var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return
    }
    
    components.queryItems = (components.queryItems ?? []) + queryItems
    self.url = components.url
  }
}
