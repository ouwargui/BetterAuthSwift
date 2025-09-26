import Combine
import Foundation

// MARK: Default methods and session
@MainActor
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
    self.baseUrl = baseURL.getBaseURL()
    self.httpClient = HTTPClient(baseURL: baseURL)
    self.sessionStore = SessionStore(httpClient: self.httpClient)

    sessionStore.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
  }

  public func getSession() async throws -> Session? {
    return try await httpClient.request(
      route: .getSession,
      responseType: Session?.self,
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

// MARK: Rest of methods
extension BetterAuthClient {
  public func forgetPassword(with body: ForgetPasswordRequest) async throws
    -> ForgetPasswordResponse
  {
    return try await httpClient.request(
      route: .forgetPassword,
      body: body,
      responseType: ForgetPasswordResponse.self
    )
  }

  public func resetPassword(with body: ResetPasswordRequest) async throws
    -> ResetPasswordResponse
  {
    return try await httpClient.request(
      route: .resetPassword,
      body: body,
      responseType: ResetPasswordResponse.self
    )
  }

  public func verifyEmail(with body: VerifyEmailRequest) async throws
    -> VerifyEmailResponse
  {
    return try await httpClient.request(
      route: .verifyEmail,
      query: body,
      responseType: VerifyEmailResponse.self
    )
  }

  public func sendVerificationEmail(with body: SendVerificationEmailRequest)
    async throws -> SendVerificationEmailResponse
  {
    return try await httpClient.request(
      route: .sendVerificationEmail,
      body: body,
      responseType: SendVerificationEmailResponse.self
    )
  }

  public func changeEmail(with body: ChangeEmailRequest) async throws
    -> ChangeEmailResponse
  {
    return try await httpClient.request(
      route: .changeEmail,
      body: body,
      responseType: ChangeEmailResponse.self
    )
  }

  public func changePassword(with body: ChangePasswordRequest) async throws
    -> ChangePasswordResponse
  {
    return try await httpClient.request(
      route: .changePassword,
      body: body,
      responseType: ChangePasswordResponse.self
    )
  }

  public func updateUser(with body: UpdateUserRequest) async throws
    -> UpdateUserResponse
  {
    return try await httpClient.request(
      route: .updateUser,
      body: body,
      responseType: UpdateUserResponse.self
    )
  }

  public func deleteUser(with body: DeleteUserRequest) async throws
    -> DeleteUserResponse
  {
    return try await httpClient.request(
      route: .deleteUser,
      body: body,
      responseType: DeleteUserResponse.self
    )
  }

  public func requestPasswordReset(with body: RequestPasswordResetRequest)
    async throws -> RequestPasswordResetResponse
  {
    return try await httpClient.request(
      route: .requestPasswordReset,
      body: body,
      responseType: RequestPasswordResetResponse.self
    )
  }

  public func listSessions() async throws -> ListSessionResponse {
    return try await httpClient.request(
      route: .listSessions,
      responseType: ListSessionResponse.self
    )
  }

  public func revokeSession(with body: RevokeSessionRequest) async throws
    -> RevokeSessionResponse
  {
    return try await httpClient.request(
      route: .revokeSession,
      body: body,
      responseType: RevokeSessionResponse.self
    )
  }

  public func revokeSessions() async throws -> RevokeSessionsResponse {
    return try await httpClient.request(
      route: .revokeSessions,
      responseType: RevokeSessionsResponse.self
    )
  }

  public func revokeOtherSessions() async throws -> RevokeOtherSessionsResponse
  {
    return try await httpClient.request(
      route: .revokeOtherSessions,
      responseType: RevokeOtherSessionsResponse.self
    )
  }

  public func linkSocial(with body: LinkSocialRequest) async throws
    -> LinkSocialResponse
  {
    return try await httpClient.request(
      route: .linkSocial,
      body: body,
      responseType: LinkSocialResponse.self
    )
  }

  public func listAccounts() async throws -> ListAccountsResponse {
    return try await httpClient.request(
      route: .listAccounts,
      responseType: ListAccountsResponse.self
    )
  }

  public func unlinkAccount(with body: UnlinkAccountRequest) async throws
    -> UnlinkAccountResponse
  {
    return try await httpClient.request(
      route: .unlinkAccount,
      body: body,
      responseType: UnlinkAccountResponse.self
    )
  }

  public func refreshToken(with body: RefreshTokenRequest) async throws
    -> RefreshTokenResponse
  {
    return try await httpClient.request(
      route: .refreshToken,
      body: body,
      responseType: RefreshTokenResponse.self
    )
  }

  public func getAccessToken(with body: GetAccessTokenRequest) async throws
    -> GetAccessTokenResponse
  {
    return try await httpClient.request(
      route: .getAccessToken,
      body: body,
      responseType: GetAccessTokenResponse.self
    )
  }

  public func accountInfo(with body: AccountInfoRequest) async throws
    -> AccountInfoResponse
  {
    return try await httpClient.request(
      route: .accountInfo,
      body: body,
      responseType: AccountInfoResponse.self
    )
  }
}

// MARK: SignIn and SignUp methods
extension BetterAuthClient {
  @MainActor
  public class SignIn {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public func email(with body: SignInEmailRequest) async throws
      -> SignInEmailResponse
    {
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

    public func social(with body: SignInSocialRequest) async throws
      -> SignInSocialResponse
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        let authResponse = try await client.httpClient.request(
          route: .signInSocial,
          body: body,
          responseType: SignInSocialResponse.self
        )

        if body.idToken != nil {
          return authResponse
        }

        if authResponse.redirect, let authURL = authResponse.url {
          let handler = OAuthHandler()

          let sessionCookie = try await handler.authenticate(
            authURL: authURL,
            callbackURLScheme: try handler.extractScheme(from: body.callbackURL)
          )

          try await client.httpClient.setCookie(sessionCookie)
        }

        return authResponse
      }
    }
  }

  @MainActor
  public class SignUp {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public func email(with body: SignUpEmailRequest) async throws
      -> SignUpEmailResponse
    {
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
