import BetterAuth

extension BetterAuthClient.SignUp {
  /// Makes a request to **/sign-up/email**.
  ///
  /// - Parameter body: ``UsernameSignUpEmailRequest``
  /// - Returns: ``SignUpEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func email(with body: UsernameSignUpEmailRequest) async throws
    -> APIResource<SignUpEmailResponse>
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.request(
        route: BetterAuthRoute.signUpEmail,
        body: body,
        responseType: SignUpEmailResponse.self
      )
    }
  }
}

extension BetterAuthClient.SignIn {
  public func username(with body: SignInUsernameRequest) async throws
    -> APIResource<SignInUsernameResponse>
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.request(
        route: BetterAuthUsernameRoute.signInUsername,
        body: body,
        responseType: SignInUsernameResponse.self
      )
    }
  }
}
