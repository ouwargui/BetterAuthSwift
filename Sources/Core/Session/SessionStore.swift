import Combine
import Foundation
import OSLog

@MainActor
public class SessionStore: ObservableObject {
  @Published public private(set) var data: Session?
  @Published public private(set) var isPending: Bool = false
  @Published public private(set) var error: BetterAuthError?

  private let httpClient: HTTPClientProtocol
  private let logger = Logger(
    subsystem: "com.betterauth",
    category: "session"
  )

  private let LISTENED_SIGNALS: [Signal] = [
    .signout,
    .passkeyVerifyAuthentication,
    .signIn,
    .signUp,
    .deleteUser,
    .updateUser,
    .verifyEmail,
  ]

  private var cancellables = Set<AnyCancellable>()

  init(httpClient: HTTPClientProtocol) {
    self.httpClient = httpClient

    SignalBus.shared.listen(to: LISTENED_SIGNALS, storeIn: &cancellables) {
      [weak self] _ in
      await self?.refreshSession()
    }
  }

  package func update(_ session: Session?) {
    self.data = session
    guard let session = session else {
      logger.debug("Session updated: nil")
      return
    }
    logger.debug("Session updated: \(session)")
  }

  private func setLoading(_ loading: Bool) {
    self.isPending = loading
  }

  package func withSessionRefresh<T: Sendable>(
    _ operation: () async throws -> T
  )
    async throws
    -> T
  {
    do {
      let result = try await operation()

      await refreshSession()

      return result
    } catch let error as BetterAuthApiError {
      if error.status == 401 {
        update(nil)
      }
      throw error
    } catch {
      throw error
    }
  }

  public func refreshSession() async {
    setLoading(true)
    defer { setLoading(false) }

    do {
      let session: APIResource<Session?, EmptyContext> =
        try await httpClient.perform(
          route: BetterAuthRoute.getSession,
          responseType: Session?.self
        )

      update(session.data)
    } catch let error as BetterAuthApiError {
      update(nil)
      self.error = .apiError(error)
    } catch let error as BetterAuthSwiftError {
      update(nil)
      self.error = .libError(error)
    } catch {
      update(nil)
      self.error = .unknownError(error)
    }
  }
}
