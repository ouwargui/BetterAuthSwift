import Foundation

public typealias EncodableAndSendable = Encodable & Sendable

public protocol HTTPClientProtocol: Sendable {
  var cookieStorage: CookieStorageProtocol { get }
  func perform<T: Decodable & Sendable, C: Codable & Sendable>(
    action: MiddlewareAction?,
    route: AuthRoutable,
    body: EncodableAndSendable?,
    query: EncodableAndSendable?,
    responseType: T.Type
  ) async throws -> APIResource<T, C>
  func perform<T: Decodable & Sendable, C: Codable & Sendable>(
    route: AuthRoutable,
    responseType: T.Type
  ) async throws -> APIResource<T, C>
  func perform<T: Decodable & Sendable, C: Codable & Sendable>(
    action: MiddlewareAction,
    route: AuthRoutable,
    responseType: T.Type
  ) async throws -> APIResource<T, C>
  func perform<T: Decodable & Sendable, C: Codable & Sendable>(
    route: AuthRoutable,
    body: EncodableAndSendable,
    responseType: T.Type
  ) async throws -> APIResource<T, C>
  func perform<T: Decodable & Sendable, C: Codable & Sendable>(
    route: AuthRoutable,
    query: EncodableAndSendable,
    responseType: T.Type
  ) async throws -> APIResource<T, C>
}

public actor HTTPClient: HTTPClientProtocol {
  private let baseURL: URL
  private let session: URLSession
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let pluginRegistry: PluginRegistry
  public let cookieStorage: CookieStorageProtocol

  package init(
    baseURL: URL,
    pluginRegistry: PluginRegistry,
    cookieStorage: CookieStorageProtocol = CookieStorage(),
  ) {
    self.baseURL = baseURL
    self.pluginRegistry = pluginRegistry
    self.cookieStorage = cookieStorage

    let config = URLSessionConfiguration.default
    config.httpCookieAcceptPolicy = .always
    config.httpCookieStorage = self.cookieStorage

    self.session = URLSession(configuration: config)
    decoder.dateDecodingStrategy = .iso8601
  }

  public init(
    baseURL: URL,
    pluginRegistry: PluginRegistry,
    cookieStorage: CookieStorageProtocol?
  ) {
    self.baseURL = baseURL
    self.pluginRegistry = pluginRegistry
    self.cookieStorage = cookieStorage ?? CookieStorage()

    let config = URLSessionConfiguration.default
    config.httpCookieAcceptPolicy = .always
    config.httpCookieStorage = self.cookieStorage

    self.session = URLSession(configuration: config)
    decoder.dateDecodingStrategy = .iso8601
  }

  private func performWillSend(
    action: MiddlewareAction?,
    request: inout HTTPRequestContext
  ) async throws {
    guard let action = action else { return }
    for plugin in await pluginRegistry.all() {
      try await plugin.willSend(action, request: &request)
    }
  }

  private func performDidReceive(
    action: MiddlewareAction?,
    response: inout HTTPResponseContext
  ) async throws {
    guard let action = action else { return }
    for plugin in await pluginRegistry.all() {
      try await plugin.didReceive(action, response: &response)
    }
  }

  public func perform<T, C>(route: AuthRoutable, responseType: T.Type)
    async throws -> APIResource<T, C>
  {
    return try await self.perform(
      action: nil,
      route: route,
      body: nil,
      query: nil,
      responseType: responseType
    )
  }

  public func perform<T, C>(
    action: MiddlewareAction,
    route: any AuthRoutable,
    responseType: T.Type
  ) async throws -> APIResource<T, C> {
    return try await self.perform(
      action: action,
      route: route,
      body: nil,
      query: nil,
      responseType: responseType
    )
  }

  public func perform<T, C>(
    route: any AuthRoutable,
    body: any EncodableAndSendable,
    responseType: T.Type
  ) async throws -> APIResource<T, C> {
    return try await self.perform(
      action: nil,
      route: route,
      body: body,
      query: nil,
      responseType: responseType
    )
  }

  public func perform<T, C>(
    route: any AuthRoutable,
    query: any EncodableAndSendable,
    responseType: T.Type
  ) async throws -> APIResource<T, C> {
    return try await self.perform(
      action: nil,
      route: route,
      body: nil,
      query: query,
      responseType: responseType
    )
  }

  public func perform<T: Decodable & Sendable, C: Codable & Sendable>(
    action: MiddlewareAction?,
    route: any AuthRoutable,
    body: (any EncodableAndSendable)?,
    query: (any EncodableAndSendable)?,
    responseType: T.Type
  ) async throws -> APIResource<T, C> {
    var reqCtx = HTTPRequestContext(
      path: route.path,
      method: route.method,
      headers: [:],
      body: body.map(AnyEncodable.init),
      query: query.map(AnyEncodable.init),
    )

    try await performWillSend(action: action, request: &reqCtx)

    let request = try reqCtx.buildUrlRequest(baseURL: baseURL, encoder: encoder)

    let (data, response) = try await session.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw BetterAuthSwiftError(message: "Invalid response")
    }

    guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 400 else {
      let coreError = try? decoder.decode(CoreError.self, from: data)
      if let coreError = coreError {
        throw BetterAuthError(coreError: coreError, response: httpResponse)
      }

      throw BetterAuthSwiftError(
        message:
          "HTTP request failed with status code \(httpResponse.statusCode)"
      )
    }

    var respCtx = HTTPResponseContext(
      urlResponse: httpResponse,
      bodyData: data,
      meta: [:]
    )

    try await performDidReceive(action: action, response: &respCtx)

    let decoded = try decoder.decode(
      APIResource<T, C>.self,
      from: respCtx.bodyData
    )

    var mergedMeta = decoded.context.meta
    for (k, v) in respCtx.meta {
      mergedMeta[k] = v
    }
    let resource = APIResource<T, C>(
      data: decoded.data,
      context: BetterAuthContext(meta: mergedMeta)
    )
    return resource
  }
}
