import Combine
import Foundation

public class BetterAuthClient: ObservableObject {
  private let baseUrl: URL
  private let httpClient: HTTPClient
  private let sessionStore: SessionStore

  public var session: Session? {
    sessionStore.current
  }

  public lazy var signIn = SignIn(client: self)
  public lazy var signUp = SignUp(client: self)
  
  private var cancellables = Set<AnyCancellable>()

  public init(baseURL: URL, plugins: [String] = []) {
    self.baseUrl = baseURL
    self.httpClient = HTTPClient(baseURL: baseURL)
    self.sessionStore = SessionStore(httpClient: self.httpClient)
    
    sessionStore.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
  }

  public func getSession() async throws -> Session {
    let session = try await httpClient.request(
      route: .getSession,
      responseType: Session.self,
    )

    return session
  }

  public func signOut() async throws -> SignOutResponse {
    return try await sessionStore.withSessionRefresh {
      let response = try await httpClient.request(
        route: .signOut,
        responseType: SignOutResponse.self
      )
      
      return response
    }
  }
}

extension BetterAuthClient {
  public class SignIn {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public func email(_ email: String, password: String) async {}

    public func social(_ provider: String, callbackURL: URL? = nil) async {}
  }

  public class SignUp {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public func email(with body: SignUpEmailRequest) async throws -> SignUpEmailResponse {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }
      
      return try await client.sessionStore.withSessionRefresh {
        let response = try await client.httpClient.request(
          route: .signUpEmail,
          body: body,
          responseType: SignUpEmailResponse.self
        )

        return response
      }
    }
  }
}
