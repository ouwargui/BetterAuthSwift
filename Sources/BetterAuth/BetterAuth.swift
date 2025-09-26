import Combine
import Foundation

// MARK: Default methods and session

/// The main client for the BetterAuth API. It's an ObservableObject that updates when session changes.
/// - Parameters:
///   - baseURL: The base URL of the BetterAuth API.
///   - plugins: The plugins to use.
@MainActor
public class BetterAuthClient: ObservableObject {
  private let baseUrl: URL
  private let httpClient: HTTPClient
  private let sessionStore: SessionStore

  /// The current session. It's a @Published variable.
  public var session: Session? {
    sessionStore.current
  }

  public lazy var signIn = SignIn(client: self)
  public lazy var signUp = SignUp(client: self)

  private var cancellables = Set<AnyCancellable>()

  public init(baseURL: URL, plugins: [String] = []) {
    self.baseUrl = baseURL.getBaseURL()
    self.httpClient = HTTPClient(baseURL: self.baseUrl)
    self.sessionStore = SessionStore(httpClient: self.httpClient)

    sessionStore.objectWillChange
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
  }

  /// Makes a request to /get-session.
  /// - Returns: ``Session``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func getSession() async throws -> Session? {
    return try await httpClient.request(
      route: .getSession,
      responseType: Session?.self,
    )
  }

  /// Makes a request to /sign-out.
  /// - Returns: ``SignOutResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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
  /// Makes a request to /forget-password.
  /// - Parameter body: ``ForgetPasswordRequest``
  /// - Returns: ``ForgetPasswordResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func forgetPassword(with body: ForgetPasswordRequest) async throws
    -> ForgetPasswordResponse
  {
    return try await httpClient.request(
      route: .forgetPassword,
      body: body,
      responseType: ForgetPasswordResponse.self
    )
  }

  /// Makes a request to /reset-password.
  /// - Parameter body: ``ResetPasswordRequest``
  /// - Returns: ``ResetPasswordResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func resetPassword(with body: ResetPasswordRequest) async throws
    -> ResetPasswordResponse
  {
    return try await httpClient.request(
      route: .resetPassword,
      body: body,
      responseType: ResetPasswordResponse.self
    )
  }

  /// Makes a request to /verify-email.
  /// - Parameter body: ``VerifyEmailRequest``
  /// - Returns: ``VerifyEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func verifyEmail(with body: VerifyEmailRequest) async throws
    -> VerifyEmailResponse
  {
    return try await self.sessionStore.withSessionRefresh {
      return try await httpClient.request(
        route: .verifyEmail,
        query: body,
        responseType: VerifyEmailResponse.self
      )
    }
  }

  /// Makes a request to /send-verification-email.
  /// - Parameter body: ``SendVerificationEmailRequest``
  /// - Returns: ``SendVerificationEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func sendVerificationEmail(with body: SendVerificationEmailRequest)
    async throws -> SendVerificationEmailResponse
  {
    return try await httpClient.request(
      route: .sendVerificationEmail,
      body: body,
      responseType: SendVerificationEmailResponse.self
    )
  }

  /// Makes a request to /change-email.
  /// - Parameter body: ``ChangeEmailRequest``
  /// - Returns: ``ChangeEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func changeEmail(with body: ChangeEmailRequest) async throws
    -> ChangeEmailResponse
  {
    return try await httpClient.request(
      route: .changeEmail,
      body: body,
      responseType: ChangeEmailResponse.self
    )
  }

  /// Makes a request to /change-password.
  /// - Parameter body: ``ChangePasswordRequest``
  /// - Returns: ``ChangePasswordResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func changePassword(with body: ChangePasswordRequest) async throws
    -> ChangePasswordResponse
  {
    return try await httpClient.request(
      route: .changePassword,
      body: body,
      responseType: ChangePasswordResponse.self
    )
  }

  /// Makes a request to /update-user.
  /// - Parameter body: ``UpdateUserRequest``
  /// - Returns: ``UpdateUserResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func updateUser(with body: UpdateUserRequest) async throws
    -> UpdateUserResponse
  {
    return try await self.sessionStore.withSessionRefresh {
      return try await httpClient.request(
        route: .updateUser,
        body: body,
        responseType: UpdateUserResponse.self
      )
    }
  }

  /// Makes a request to /delete-user.
  /// - Parameter body: ``DeleteUserRequest``
  /// - Returns: ``DeleteUserResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func deleteUser(with body: DeleteUserRequest) async throws
    -> DeleteUserResponse
  {
    return try await self.sessionStore.withSessionRefresh {
      return try await httpClient.request(
        route: .deleteUser,
        body: body,
        responseType: DeleteUserResponse.self
      )
    }
  }

  /// Makes a request to /request-password-reset.
  /// - Parameter body: ``RequestPasswordResetRequest``
  /// - Returns: ``RequestPasswordResetResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func requestPasswordReset(with body: RequestPasswordResetRequest)
    async throws -> RequestPasswordResetResponse
  {
    return try await httpClient.request(
      route: .requestPasswordReset,
      body: body,
      responseType: RequestPasswordResetResponse.self
    )
  }

  /// Makes a request to /list-sessions.
  /// - Returns: ``ListSessionResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func listSessions() async throws -> ListSessionResponse {
    return try await httpClient.request(
      route: .listSessions,
      responseType: ListSessionResponse.self
    )
  }

  /// Makes a request to /revoke-session.
  /// - Parameter body: ``RevokeSessionRequest``
  /// - Returns: ``RevokeSessionResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func revokeSession(with body: RevokeSessionRequest) async throws
    -> RevokeSessionResponse
  {
    return try await httpClient.request(
      route: .revokeSession,
      body: body,
      responseType: RevokeSessionResponse.self
    )
  }

  /// Makes a request to /revoke-sessions.
  /// - Returns: ``RevokeSessionsResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func revokeSessions() async throws -> RevokeSessionsResponse {
    return try await httpClient.request(
      route: .revokeSessions,
      responseType: RevokeSessionsResponse.self
    )
  }

  /// Makes a request to /revoke-other-sessions.
  /// - Returns: ``RevokeOtherSessionsResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func revokeOtherSessions() async throws -> RevokeOtherSessionsResponse
  {
    return try await httpClient.request(
      route: .revokeOtherSessions,
      responseType: RevokeOtherSessionsResponse.self
    )
  }

  /// Makes a request to /link-social.
  /// - Parameter body: ``LinkSocialRequest``
  /// - Returns: ``LinkSocialResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func linkSocial(with body: LinkSocialRequest) async throws
    -> LinkSocialResponse
  {
    return try await httpClient.request(
      route: .linkSocial,
      body: body,
      responseType: LinkSocialResponse.self
    )
  }

  /// Makes a request to /list-accounts.
  /// - Returns: ``ListAccountsResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func listAccounts() async throws -> ListAccountsResponse {
    return try await httpClient.request(
      route: .listAccounts,
      responseType: ListAccountsResponse.self
    )
  }

  /// Makes a request to /unlink-account.
  /// - Parameter body: ``UnlinkAccountRequest``
  /// - Returns: ``UnlinkAccountResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func unlinkAccount(with body: UnlinkAccountRequest) async throws
    -> UnlinkAccountResponse
  {
    return try await httpClient.request(
      route: .unlinkAccount,
      body: body,
      responseType: UnlinkAccountResponse.self
    )
  }

  /// Makes a request to /refresh-token.
  /// - Parameter body: ``RefreshTokenRequest``
  /// - Returns: ``RefreshTokenResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func refreshToken(with body: RefreshTokenRequest) async throws
    -> RefreshTokenResponse
  {
    return try await httpClient.request(
      route: .refreshToken,
      body: body,
      responseType: RefreshTokenResponse.self
    )
  }

  /// Makes a request to /get-access-token.
  /// - Parameter body: ``GetAccessTokenRequest``
  /// - Returns: ``GetAccessTokenResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func getAccessToken(with body: GetAccessTokenRequest) async throws
    -> GetAccessTokenResponse
  {
    return try await httpClient.request(
      route: .getAccessToken,
      body: body,
      responseType: GetAccessTokenResponse.self
    )
  }

  /// Makes a request to /account-info.
  /// - Parameter body: ``AccountInfoRequest``
  /// - Returns: ``AccountInfoResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to /sign-in/email.
    /// - Parameter body: ``SignInEmailRequest``
    /// - Returns: ``SignInEmailResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to /sign-in/social.
    /// - Parameter body: ``SignInSocialRequest``
    /// - Returns: ``SignInSocialResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to /sign-up/email.
    /// - Parameter body: ``SignUpEmailRequest``
    /// - Returns: ``SignUpEmailResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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
