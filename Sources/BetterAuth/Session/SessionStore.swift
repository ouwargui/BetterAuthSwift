import Combine
import OSLog
import Foundation

@MainActor
package class SessionStore: ObservableObject {
  @Published private(set) var current: Session?
  @Published private(set) var isLoading: Bool = false

  private let httpClient: HTTPClientProtocol
  private let logger = Logger(subsystem: "com.betterauth", category: "SessionStore")

  init(httpClient: HTTPClientProtocol) {
    self.httpClient = httpClient

    Task {
      await refreshSession()
    }
  }

  package func update(_ session: Session?) {
    self.current = session
    guard let session = session else {
      logger.debug("Session updated: nil")
      return
    }
    logger.debug("Session updated: \(session)")
  }

  private func setLoading(_ loading: Bool) {
    self.isLoading = loading
  }

  package func withSessionRefresh<T>(_ operation: () async throws -> T)
    async throws
    -> T
  {
    setLoading(true)

    defer { setLoading(false) }

    do {
      let result = try await operation()

      await refreshSession()

      return result
    } catch let error as BetterAuthError {
      if error.status == 401 {
        update(nil)
      }
      throw error
    } catch {
      throw error
    }
  }

  private func refreshSession() async {
    do {
      let session: APIResource<Session?, EmptyContext> =
        try await httpClient.perform(
          route: BetterAuthRoute.getSession,
          responseType: Session?.self
        )

      update(session.data)
    } catch {
      update(nil)
    }
  }
}
