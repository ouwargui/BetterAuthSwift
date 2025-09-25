import Foundation

private struct Empty: Codable {}

actor HTTPClient {
  private let baseURL: URL
  private let session = URLSession.shared
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(baseURL: URL) {
    self.baseURL = baseURL
    self.session.configuration.httpCookieAcceptPolicy = .always

    decoder.dateDecodingStrategy = .iso8601
  }
  
  private func getHost() throws -> URL {
    guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
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

  func setCookie(_ cookie: String) throws {
    let host = try getHost()
    let httpCookie = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": cookie], for: host)

    guard let cookie = httpCookie.first else {
      throw BetterAuthSwiftError(message: "Failed to get session cookie from callbackURL")
    }

    HTTPCookieStorage.shared.setCookie(cookie)
  }

  func request<T: Decodable, B: Encodable>(
    route: BetterAuthRoute,
    body: B?,
    responseType: T.Type
  ) async throws -> T {
    try await request(
      path: route.path,
      method: route.method,
      responseType: responseType,
      body: body
    )
  }

  func request<T: Decodable>(
    route: BetterAuthRoute,
    responseType: T.Type
  ) async throws -> T {
    try await request(
      path: route.path,
      method: route.method,
      responseType: responseType,
      body: (nil as Empty?)
    )
  }

  private func request<T: Decodable, B: Encodable>(
    path: String,
    method: String,
    responseType: T.Type,
    body: B?
  ) async throws -> T {
    var url: URL {
      if #available(macOS 13.0, iOS 16.0, *) {
        return baseURL.appending(path: path)
      } else {
        return baseURL.appendingPathComponent(path)
      }
    }

    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    if let body = body {
      request.httpBody = try encoder.encode(body)
    }

    let (data, response) = try await session.data(for: request)
    
    print(data.json)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw BetterAuthSwiftError(message: "Invalid response")
    }

    if httpResponse.statusCode >= 400 {
      let errorBody = try? decoder.decode(BetterAuthError.self, from: data)
      throw errorBody ?? BetterAuthError(
        code: nil,
        message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode),
        status: httpResponse.statusCode,
        statusText: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
      )
    }

    return try decoder.decode(T.self, from: data)
  }
}
