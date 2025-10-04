import BetterAuth

extension BetterAuthClient.SignUp {
  /// Makes a request to **/sign-up/email**.
  ///
  /// - Parameter body: ``UsernameSignUpEmailRequest``
  /// - Returns: ``SignUpEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func email(with body: UsernameSignUpEmailRequest) async throws
    -> APIResource<SignUpEmailResponse, EmptyContext>
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
  public func username(with body: SignInUsernameRequest) async throws
    -> APIResource<SignInUsernameResponse?, SignInContext>
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      let res:
        APIResource<PluginOptional<SignInUsernameResponse>, SignInContext> =
          try await client.httpClient.perform(
            action: .signInUsername,
            route: BetterAuthUsernameRoute.signInUsername,
            body: body,
            query: nil,
            responseType: PluginOptional<SignInUsernameResponse>.self
          )

      return .init(from: res)
    }
  }
}
