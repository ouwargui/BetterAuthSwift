import BetterAuth
import Foundation

#if !os(watchOS)
  extension BetterAuthClient.SignIn {
    public typealias GenericOAuthSignInOAuth2 = APIResource<
      GenericOAuthSignInResponse, EmptyContext
    >

    /// Make a request to **/sign-in/oauth2**.
    /// - Parameter body: ``GenericOAuthSignInRequest``
    /// - Returns: ``GenericOAuthSignInOAuth2``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func oauth2(with body: GenericOAuthSignInRequest) async throws
      -> GenericOAuthSignInOAuth2
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await SignalBus.shared.emittingSignal(.signIn) {
        let response: GenericOAuthSignInOAuth2 = try await client.httpClient.perform(
          route: BetterAuthGenericOAuthRoute.signInOAuth2,
          body: body,
          responseType: GenericOAuthSignInResponse.self
        )

        guard response.data.redirect, let authURL = response.data.url else {
          return response
        }

        guard let callbackURL = body.callbackURL else {
          throw BetterAuthSwiftError(
            message:
              "callbackURL is required to handle the OAuth redirect when redirect is enabled."
          )
        }

        let proxyURL = try client.genericOAuth.makeAuthorizationProxyURL(
          for: authURL
        )

        let handler = OAuthHandler()
        let sessionCookie = try await handler.authenticate(
          authURL: proxyURL.absoluteString,
          callbackURLScheme: try handler.extractScheme(from: callbackURL)
        )

        try client.httpClient.cookieStorage.setCookie(
          sessionCookie,
          for: client.baseUrl
        )

        return response
      }
    }
  }
#endif

extension BetterAuthClient {
  public var genericOAuth: GenericOAuth {
    self.pluginRegistry.get(id: GenericOAuthPlugin.id)
  }
}
