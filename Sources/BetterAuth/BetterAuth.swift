import Combine
import Foundation

private struct Empty: Codable {}

public class BetterAuthClient {
  private let baseUrl: URL
  private let httpClient: HTTPClient

  public lazy var signIn = SignIn(client: self)
  public lazy var signUp = SignUp(client: self)

  @Published public private(set) var session: Session?

  public init(baseURL: URL, plugins: [String] = []) {
    self.baseUrl = baseURL
    self.httpClient = HTTPClient(baseURL: baseURL)
  }

  public func getSession() async throws -> Session {
    let session = try await httpClient.request(
      route: .getSession,
      responseType: Session.self,
    )

    self.session = session

    return session
  }

  public func signOut() async {}
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

      let session = try await client.httpClient.request(
        route: .signUpEmail,
        body: body,
        responseType: SignUpEmailResponse.self
      )

      return session
    }
  }
}
