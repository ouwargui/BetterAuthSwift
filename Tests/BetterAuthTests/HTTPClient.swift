import BetterAuth
import Foundation

actor MockHTTPClient: HTTPClientProtocol {
  let cookieStorage: CookieStorageProtocol

  init(cookieStorage: CookieStorageProtocol) {
    self.cookieStorage = cookieStorage
  }

  func request<
    T: Decodable & Sendable,
    B: Encodable & Sendable,
    Q: Encodable & Sendable
  >(
    path: String,
    method: String,
    responseType: T.Type,
    body: B?,
    query: Q?
  ) async throws -> T {
    throw BetterAuthSwiftError(message: "Not implemented")
  }

  func request<T: Decodable & Sendable>(
    route: BetterAuthRoute,
    responseType: T.Type
  ) async throws -> T {
    if route == .getSession {
      let now = Date()
      let user = User(
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
      return try JSONDecoder().decode(T.self, from: data)
    }

    throw BetterAuthSwiftError(message: "Not implemented in test")
  }

  func request<T: Decodable & Sendable, B: Encodable & Sendable>(
    route: BetterAuthRoute,
    body: B?,
    responseType: T.Type
  ) async throws -> T {
    throw BetterAuthSwiftError(message: "Not implemented in test")
  }

  func request<T: Decodable & Sendable, Q: Encodable & Sendable>(
    route: BetterAuthRoute,
    query: Q?,
    responseType: T.Type
  ) async throws -> T {
    throw BetterAuthSwiftError(message: "Not implemented in test")
  }
}
