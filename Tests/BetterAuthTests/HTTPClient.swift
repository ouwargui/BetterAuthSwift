import BetterAuth
import Foundation

actor MockHTTPClient: HTTPClientProtocol {
  let baseURL: URL
  let pluginRegistry: PluginRegistry
  let cookieStorage: CookieStorageProtocol

  init(
    baseURL: URL,
    pluginRegistry: PluginRegistry,
    cookieStorage: (CookieStorageProtocol)?
  ) {
    self.baseURL = baseURL
    self.pluginRegistry = pluginRegistry
    self.cookieStorage =
      cookieStorage ?? BetterAuth.CookieStorage(storage: InMemoryStorage())
  }

  func perform<T, C>(
    action: BetterAuth.MiddlewareAction?,
    route: any BetterAuth.AuthRoutable,
    body: (any EncodableAndSendable)?,
    query: (any EncodableAndSendable)?,
    responseType: T.Type
  ) async throws -> BetterAuth.APIResource<T, C>
  where
    T: Decodable, T: Encodable, T: Sendable, C: Decodable, C: Encodable,
    C: Sendable
  {
    if route.path == BetterAuthRoute.getSession.path {
      let now = Date()
      let user = SessionUser(
        id: "user_1",
        email: "test@example.com",
        name: "Test User",
        image: nil,
        emailVerified: true,
        createdAt: now,
        updatedAt: now
      )
      let sessionData = SessionData(
        id: "session_1",
        userId: user.id,
        token: "token",
        ipAddress: "127.0.0.1",
        userAgent: "testing",
        expiresAt: now.addingTimeInterval(3600),
        createdAt: now,
        updatedAt: now
      )
      let session = Session(session: sessionData, user: user)
      let data = try JSONEncoder().encode(session)
      return try JSONDecoder().decode(APIResource<T, C>.self, from: data)
    }
    
    throw BetterAuthSwiftError(message: "Not implemented")
  }

  func perform<T, C>(route: any BetterAuth.AuthRoutable, responseType: T.Type)
    async throws -> BetterAuth.APIResource<T, C>
  where
    T: Decodable, T: Encodable, T: Sendable, C: Decodable, C: Encodable,
    C: Sendable
  {
    throw BetterAuthSwiftError(message: "Not implemented")
  }

  func perform<T, C>(
    action: BetterAuth.MiddlewareAction,
    route: any BetterAuth.AuthRoutable,
    responseType: T.Type
  ) async throws -> BetterAuth.APIResource<T, C>
  where
    T: Decodable, T: Encodable, T: Sendable, C: Decodable, C: Encodable,
    C: Sendable
  {
    throw BetterAuthSwiftError(message: "Not implemented")
  }

  func perform<T, C>(
    route: any BetterAuth.AuthRoutable,
    body: any EncodableAndSendable,
    responseType: T.Type
  ) async throws -> BetterAuth.APIResource<T, C>
  where
    T: Decodable, T: Encodable, T: Sendable, C: Decodable, C: Encodable,
    C: Sendable
  {
    throw BetterAuthSwiftError(message: "Not implemented")
  }

  func perform<T, C>(
    route: any BetterAuth.AuthRoutable,
    query: any EncodableAndSendable,
    responseType: T.Type
  ) async throws -> BetterAuth.APIResource<T, C>
  where
    T: Decodable, T: Encodable, T: Sendable, C: Decodable, C: Encodable,
    C: Sendable
  {
    throw BetterAuthSwiftError(message: "Not implemented")
  }
}
