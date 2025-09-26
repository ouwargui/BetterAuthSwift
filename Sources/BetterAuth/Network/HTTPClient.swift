import Foundation

private struct Empty: Codable {}

actor HTTPClient {
  private let baseURL: URL
  private let session: URLSession
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let cookieStorage = CookieStorage()

  init(baseURL: URL) {
    self.baseURL = baseURL
    let config = URLSessionConfiguration.default
    config.httpCookieAcceptPolicy = .always
    config.httpCookieStorage = cookieStorage

    self.session = URLSession(configuration: config)
    decoder.dateDecodingStrategy = .iso8601
  }

  func setCookie(_ cookie: String) throws {
    let host = try baseURL.getHost()
    let httpCookie = HTTPCookie.cookies(
      withResponseHeaderFields: ["Set-Cookie": cookie],
      for: host
    )

    guard let cookie = httpCookie.first else {
      throw BetterAuthSwiftError(
        message: "Failed to get session cookie from callbackURL"
      )
    }

    cookieStorage.setCookie(cookie)
  }

  func request<T: Decodable, B: Encodable>(
    route: BetterAuthRoute,
    body: B,
    responseType: T.Type
  ) async throws -> T {
    try await request(
      path: route.path,
      method: route.method,
      responseType: responseType,
      body: body,
      query: (nil as Empty?)
    )
  }

  func request<T: Decodable, Q: Encodable>(
    route: BetterAuthRoute,
    query: Q,
    responseType: T.Type
  ) async throws -> T {
    try await request(
      path: route.path,
      method: route.method,
      responseType: responseType,
      body: (nil as Empty?),
      query: query
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
      body: (nil as Empty?),
      query: (nil as Empty?)
    )
  }

  private func request<T: Decodable, B: Encodable, Q: Encodable>(
    path: String,
    method: String,
    responseType: T.Type,
    body: B?,
    query: Q?
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
    request.httpShouldHandleCookies = true

    if let body = body {
      request.httpBody = try encoder.encode(body)
    }
    
    if let query = query {
      request.addQueryItems(query.toQueryItems())
    }

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw BetterAuthSwiftError(message: "Invalid response")
    }

    if httpResponse.statusCode >= 400 {
      let errorBody = try? decoder.decode(BetterAuthError.self, from: data)
      throw errorBody
        ?? BetterAuthError(
          code: nil,
          message: HTTPURLResponse.localizedString(
            forStatusCode: httpResponse.statusCode
          ),
          status: httpResponse.statusCode,
          statusText: HTTPURLResponse.localizedString(
            forStatusCode: httpResponse.statusCode
          )
        )
    }

    return try decoder.decode(T.self, from: data)
  }
}
