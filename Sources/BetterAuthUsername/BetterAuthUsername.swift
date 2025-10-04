import BetterAuth

extension BetterAuthClient {
  public typealias UsernameIsUsernameAvailable = APIResource<
    UsernameIsUsernameAvailableResponse, EmptyContext
  >

  public func isUsernameAvailable(with body: UsernameIsUsernameAvailableRequest)
    async throws -> UsernameIsUsernameAvailable
  {
    return try await self.httpClient.perform(
      route: BetterAuthUsernameRoute.isUsernameAvailable,
      body: body,
      responseType: UsernameIsUsernameAvailableResponse.self
    )
  }
}

extension BetterAuthClient.SignUp {
  public typealias UsernameSignUpEmail = APIResource<
    SignUpEmailResponse, EmptyContext
  >

  /// Makes a request to **/sign-up/email**.
  ///
  /// - Parameter body: ``UsernameSignUpEmailRequest``
  /// - Returns: ``SignUpEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func email(with body: UsernameSignUpEmailRequest) async throws
    -> UsernameSignUpEmail
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.perform(
        route: BetterAuthRoute.signUpEmail,
        body: body,
        responseType: SignUpEmailResponse.self
      )
    }
  }
}

extension BetterAuthClient.SignIn {
  public typealias UsernameSignInUsername = APIResource<
    UsernameSignInUsernameResponse?, SignInContext
  >

  /// Makes a request to **/sign-in/username**.
  ///
  /// - Parameter body: ``UsernameSignUpEmailRequest``
  /// - Returns: ``SignInUsernameResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func username(with body: UsernameSignInUsernameRequest) async throws
    -> UsernameSignInUsername
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      let res:
        APIResource<PluginOptional<UsernameSignInUsernameResponse>, SignInContext> =
          try await client.httpClient.perform(
            action: .signInUsername,
            route: BetterAuthUsernameRoute.signInUsername,
            body: body,
            query: nil,
            responseType: PluginOptional<UsernameSignInUsernameResponse>.self
          )

      return .init(from: res)
    }
  }
}
