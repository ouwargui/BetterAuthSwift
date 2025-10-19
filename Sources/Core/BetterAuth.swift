import Combine
import Foundation

// MARK: Default methods and session

/// The main client for the BetterAuth API. It's an ObservableObject that updates when session changes.
/// - Parameters:
///   - baseURL: The base URL of your BetterAuth API. Uses `/api/auth` path by default unless you send a different path.
///   - httpClient: You can pass a custom implementation that conforms to ``HTTPClientProtocol``. It uses ``HTTPClient`` by default.
@MainActor
public class BetterAuthClient: ObservableObject {
  package let baseUrl: URL
  package let httpClient: HTTPClientProtocol
  package let pluginRegistry: PluginRegistry

  public lazy var signIn = SignIn(client: self)
  public lazy var signUp = SignUp(client: self)

  /// Session store. Will be updated on session changes
  public let session: SessionStore

  package var cancellables = Set<AnyCancellable>()

  public init(
    baseURL: URL,
    plugins: [PluginFactory] = [],
    httpClient: HTTPClientProtocol? = nil
  ) {
    self.baseUrl = baseURL.getBaseURL()
    self.pluginRegistry = PluginRegistry(factories: plugins)
    self.httpClient =
      httpClient
      ?? HTTPClient(baseURL: self.baseUrl, pluginRegistry: self.pluginRegistry)
    self.session = SessionStore(httpClient: self.httpClient)
    self.pluginRegistry.register(client: self)

    session.objectWillChange
      .sink { [weak self] _ in self?.objectWillChange.send() }
      .store(in: &cancellables)
  }
}

// MARK: Route methods
extension BetterAuthClient {
  /// Returns the Better Auth cookie
  public func getCookie() -> HTTPCookie? {
    return self.httpClient.cookieStorage.getBetterAuthCookie()
  }

  public typealias GetSession = APIResource<Session?, EmptyContext>

  /// Make a request to /get-session.
  /// - Returns: ``GetSession``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func getSession() async throws -> GetSession {
    let res: GetSession = try await httpClient.perform(
      route: BetterAuthRoute.getSession,
      responseType: Session?.self,
    )
    self.session.update(res.data)
    return res
  }

  public typealias SignOut = APIResource<SignOutResponse, EmptyContext>

  /// Make a request to /sign-out.
  /// - Returns: ``SignOut``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func signOut() async throws -> SignOut {
    return try await self.session.withSessionRefresh {
      return try await httpClient.perform(
        route: BetterAuthRoute.signOut,
        responseType: SignOutResponse.self
      )
    }
  }

  public typealias ForgetPassword = APIResource<
    ForgetPasswordResponse, EmptyContext
  >

  /// Make a request to /forget-password.
  /// - Parameter body: ``ForgetPasswordRequest``
  /// - Returns: ``ForgetPassword``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func forgetPassword(with body: ForgetPasswordRequest) async throws
    -> ForgetPassword
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.forgetPassword,
      body: body,
      responseType: ForgetPasswordResponse.self
    )
  }

  public typealias ResetPassword = APIResource<
    ResetPasswordResponse, EmptyContext
  >

  /// Make a request to /reset-password.
  /// - Parameter body: ``ResetPasswordRequest``
  /// - Returns: ``ResetPassword``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func resetPassword(with body: ResetPasswordRequest) async throws
    -> ResetPassword
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.resetPassword,
      body: body,
      responseType: ResetPasswordResponse.self
    )
  }

  public typealias VerifyEmail = APIResource<VerifyEmailResponse, EmptyContext>

  /// Make a request to /verify-email.
  /// - Parameter body: ``VerifyEmailRequest``
  /// - Returns: ``VerifyEmail``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func verifyEmail(with body: VerifyEmailRequest) async throws
    -> VerifyEmail
  {
    return try await self.session.withSessionRefresh {
      return try await httpClient.perform(
        route: BetterAuthRoute.verifyEmail,
        query: body,
        responseType: VerifyEmailResponse.self
      )
    }
  }

  public typealias SendVerificationEmail = APIResource<
    SendVerificationEmailResponse, EmptyContext
  >

  /// Make a request to /send-verification-email.
  /// - Parameter body: ``SendVerificationEmailRequest``
  /// - Returns: ``SendVerificationEmail``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func sendVerificationEmail(with body: SendVerificationEmailRequest)
    async throws -> SendVerificationEmail
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.sendVerificationEmail,
      body: body,
      responseType: SendVerificationEmailResponse.self
    )
  }

  public typealias ChangeEmail = APIResource<ChangeEmailResponse, EmptyContext>

  /// Make a request to /change-email.
  /// - Parameter body: ``ChangeEmailRequest``
  /// - Returns: ``ChangeEmail``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func changeEmail(with body: ChangeEmailRequest) async throws
    -> ChangeEmail
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.changeEmail,
      body: body,
      responseType: ChangeEmailResponse.self
    )
  }

  public typealias ChangePassword = APIResource<
    ChangePasswordResponse, EmptyContext
  >

  /// Make a request to /change-password.
  /// - Parameter body: ``ChangePasswordRequest``
  /// - Returns: ``ChangePassword``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func changePassword(with body: ChangePasswordRequest) async throws
    -> ChangePassword
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.changePassword,
      body: body,
      responseType: ChangePasswordResponse.self
    )
  }

  public typealias UpdateUser = APIResource<UpdateUserResponse, EmptyContext>

  /// Make a request to /update-user.
  /// - Parameter body: ``UpdateUserRequest``
  /// - Returns: ``UpdateUser``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func updateUser(with body: UpdateUserRequest) async throws
    -> UpdateUser
  {
    return try await self.session.withSessionRefresh {
      return try await httpClient.perform(
        route: BetterAuthRoute.updateUser,
        body: body,
        responseType: UpdateUserResponse.self
      )
    }
  }

  public typealias DeleteUser = APIResource<DeleteUserResponse, EmptyContext>

  /// Make a request to /delete-user.
  /// - Parameter body: ``DeleteUserRequest``
  /// - Returns: ``DeleteUser``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func deleteUser(with body: DeleteUserRequest) async throws
    -> DeleteUser
  {
    return try await self.session.withSessionRefresh {
      return try await httpClient.perform(
        route: BetterAuthRoute.deleteUser,
        body: body,
        responseType: DeleteUserResponse.self
      )
    }
  }

  public typealias RequestPasswordReset = APIResource<
    RequestPasswordResetResponse, EmptyContext
  >

  /// Make a request to /request-password-reset.
  /// - Parameter body: ``RequestPasswordResetRequest``
  /// - Returns: ``RequestPasswordReset``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func requestPasswordReset(with body: RequestPasswordResetRequest)
    async throws -> RequestPasswordReset
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.requestPasswordReset,
      body: body,
      responseType: RequestPasswordResetResponse.self
    )
  }

  public typealias ListSessions = APIResource<ListSessionResponse, EmptyContext>

  /// Make a request to /list-sessions.
  /// - Returns: ``ListSessions``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func listSessions() async throws -> ListSessions {
    return try await httpClient.perform(
      route: BetterAuthRoute.listSessions,
      responseType: ListSessionResponse.self
    )
  }

  public typealias RevokeSession = APIResource<
    RevokeSessionResponse, EmptyContext
  >

  /// Make a request to /revoke-session.
  /// - Parameter body: ``RevokeSessionRequest``
  /// - Returns: ``RevokeSession``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func revokeSession(with body: RevokeSessionRequest) async throws
    -> RevokeSession
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.revokeSession,
      body: body,
      responseType: RevokeSessionResponse.self
    )
  }
  public typealias RevokeSessions = APIResource<
    RevokeSessionsResponse, EmptyContext
  >

  /// Make a request to /revoke-sessions.
  /// - Returns: ``RevokeSessions``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func revokeSessions() async throws -> RevokeSessions {
    return try await httpClient.perform(
      route: BetterAuthRoute.revokeSessions,
      responseType: RevokeSessionsResponse.self
    )
  }
  public typealias RevokeOtherSessions = APIResource<
    RevokeOtherSessionsResponse, EmptyContext
  >

  /// Make a request to /revoke-other-sessions.
  /// - Returns: ``RevokeOtherSessions``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func revokeOtherSessions() async throws -> RevokeOtherSessions {
    return try await httpClient.perform(
      route: BetterAuthRoute.revokeOtherSessions,
      responseType: RevokeOtherSessionsResponse.self
    )
  }

  public typealias LinkSocial = APIResource<LinkSocialResponse, EmptyContext>

  /// Make a request to /link-social.
  /// - Parameter body: ``LinkSocialRequest``
  /// - Returns: ``LinkSocial``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func linkSocial(with body: LinkSocialRequest) async throws
    -> LinkSocial
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.linkSocial,
      body: body,
      responseType: LinkSocialResponse.self
    )
  }
  public typealias ListAccounts = APIResource<
    ListAccountsResponse, EmptyContext
  >

  /// Make a request to /list-accounts.
  /// - Returns: ``ListAccounts``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func listAccounts() async throws -> ListAccounts {
    return try await httpClient.perform(
      route: BetterAuthRoute.listAccounts,
      responseType: ListAccountsResponse.self
    )
  }

  public typealias UnlinkAccount = APIResource<
    UnlinkAccountResponse, EmptyContext
  >

  /// Make a request to /unlink-account.
  /// - Parameter body: ``UnlinkAccountRequest``
  /// - Returns: ``UnlinkAccount``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func unlinkAccount(with body: UnlinkAccountRequest) async throws
    -> UnlinkAccount
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.unlinkAccount,
      body: body,
      responseType: UnlinkAccountResponse.self
    )
  }

  public typealias RefreshToken = APIResource<
    RefreshTokenResponse, EmptyContext
  >

  /// Make a request to /refresh-token.
  /// - Parameter body: ``RefreshTokenRequest``
  /// - Returns: ``RefreshToken``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func refreshToken(with body: RefreshTokenRequest) async throws
    -> RefreshToken
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.refreshToken,
      body: body,
      responseType: RefreshTokenResponse.self
    )
  }

  public typealias GetAccessToken = APIResource<
    GetAccessTokenResponse, EmptyContext
  >

  /// Make a request to /get-access-token.
  /// - Parameter body: ``GetAccessTokenRequest``
  /// - Returns: ``GetAccessToken``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func getAccessToken(with body: GetAccessTokenRequest) async throws
    -> GetAccessToken
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.getAccessToken,
      body: body,
      responseType: GetAccessTokenResponse.self
    )
  }

  public typealias AccountInfo = APIResource<AccountInfoResponse, EmptyContext>

  /// Make a request to /account-info.
  /// - Parameter body: ``AccountInfoRequest``
  /// - Returns: ``AccountInfo``
  /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
  public func accountInfo(with body: AccountInfoRequest) async throws
    -> AccountInfo
  {
    return try await httpClient.perform(
      route: BetterAuthRoute.accountInfo,
      body: body,
      responseType: AccountInfoResponse.self
    )
  }
}

// MARK: SignIn and SignUp methods
extension BetterAuthClient {
  @MainActor
  public class SignIn {
    package weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public typealias SignInEmail = APIResource<
      SignInEmailResponse?, SignInContext
    >

    /// Make a request to /sign-in/email.
    /// - Parameter body: ``SignInEmailRequest``
    /// - Returns: ``SignInEmail``
    /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
    public func email(with body: SignInEmailRequest) async throws
      -> SignInEmail
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.session.withSessionRefresh {
        let res:
          APIResource<PluginOptional<SignInEmailResponse>, SignInContext> =
            try await client.httpClient.perform(
              action: .signInEmail,
              route: BetterAuthRoute.signInEmail,
              body: body,
              query: nil,
              responseType: PluginOptional<SignInEmailResponse>.self
            )
        return .init(from: res)
      }
    }

    public typealias SignInSocial = APIResource<
      SignInSocialResponse, EmptyContext
    >

    #if !os(watchOS)
      /// Make a request to /sign-in/social.
      /// - Parameter body: ``SignInSocialRequest``
      /// - Returns: ``SignInSocial``
      /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
      public func social(with body: SignInSocialRequest) async throws
        -> SignInSocial
      {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        return try await client.session.withSessionRefresh {
          let authResponse: SignInSocial =
            try await client.httpClient.perform(
              route: BetterAuthRoute.signInSocial,
              body: body,
              responseType: SignInSocialResponse.self
            )

          if body.idToken != nil {
            return authResponse
          }

          if authResponse.data.redirect, let authURL = authResponse.data.url {
            let handler = OAuthHandler()

            let sessionCookie = try await handler.authenticate(
              authURL: authURL,
              callbackURLScheme: try handler.extractScheme(
                from: body.callbackURL
              )
            )

            try client.httpClient.cookieStorage.setCookie(
              sessionCookie,
              for: client.baseUrl
            )
          }

          return authResponse
        }
      }
    #endif
  }

  @MainActor
  public class SignUp {
    package weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public typealias SignUpEmail = APIResource<
      SignUpEmailResponse, EmptyContext
    >

    /// Make a request to /sign-up/email.
    /// - Parameter body: ``SignUpEmailRequest``
    /// - Returns: ``SignUpEmail``
    /// - Throws: ``BetterAuthApiError`` - ``BetterAuthSwiftError``
    public func email(with body: SignUpEmailRequest) async throws
      -> SignUpEmail
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.session.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthRoute.signUpEmail,
          body: body,
          responseType: SignUpEmailResponse.self
        )
      }
    }
  }
}
