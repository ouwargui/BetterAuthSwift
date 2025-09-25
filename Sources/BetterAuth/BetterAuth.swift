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
    return try await httpClient.request(
      route: .getSession,
      responseType: Session.self,
    )
  }

  public func signOut() async throws -> SignOutResponse {
    return try await sessionStore.withSessionRefresh {
      return try await httpClient.request(
        route: .signOut,
        responseType: SignOutResponse.self
      )
    }
  }
}

extension BetterAuthClient {
  public class SignIn {
    private weak var client: BetterAuthClient?
    private var oauthHandler: OAuthHandler?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public func email(with body: SignInEmailRequest) async throws -> SignInEmailResponse{
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }
      
      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: .signInEmail,
          body: body,
          responseType: SignInEmailResponse.self
        )
      }
    }

    public func social(with body: SignInSocialRequest) async throws -> SignInSocialResponse {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        let authResponse = try await client.httpClient.request(
          route: .signInSocial,
          body: body,
          responseType: SignInSocialResponse.self
        )
        
        print(authResponse)

        if body.idToken != nil {
          return authResponse
        }

        if authResponse.redirect, let authURL = authResponse.url {
          self.oauthHandler = OAuthHandler()

          let callbackURL = try await oauthHandler!.authenticate(
            authURL: authURL,
            callbackURLScheme: try oauthHandler!.extractScheme(from: body.callbackURL)
          )
          
          self.oauthHandler = nil
        }

        return authResponse
      }
    }
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
        return try await client.httpClient.request(
          route: .signUpEmail,
          body: body,
          responseType: SignUpEmailResponse.self
        )
      }
    }
  }
}
