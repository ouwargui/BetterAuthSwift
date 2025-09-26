import Foundation
import Combine

@MainActor
class SessionStore: ObservableObject {
  @Published private(set) var current: Session?
  @Published private(set) var isLoading: Bool = false
  
  private let httpClient: HTTPClient
  
  init(httpClient: HTTPClient) {
    self.httpClient = httpClient
    
    Task {
      await refreshSession()
    }
  }

  private func update(_ session: Session?) {
    self.current = session
  }

  private func setLoading(_ loading: Bool) {
    self.isLoading = loading
  }
  
  func withSessionRefresh<T>(_ operation: () async throws -> T) async throws -> T {
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
    }
  }

  private func refreshSession() async {
    do {
      let session = try await httpClient.request(
        route: .getSession,
        responseType: Session.self
      )

      update(session)
    } catch {
      update(nil)
    }
  }
}
