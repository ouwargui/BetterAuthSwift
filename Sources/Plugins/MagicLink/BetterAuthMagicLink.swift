import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public typealias MagicLinkSignInMagicLink = APIResource<
    MagicLinkSignInMagicLinkResponse, EmptyContext
  >

  /// Make a request to **/sign-in/magic-link**
  /// - Parameter body: ``MagicLinkSignInMagicLinkRequest``
  /// - Returns: ``MagicLinkSignInMagicLink``
  /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func magicLink(with body: MagicLinkSignInMagicLinkRequest) async throws
    -> MagicLinkSignInMagicLink
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthMagicLinkRoute.signInMagicLink,
      body: body,
      responseType: MagicLinkSignInMagicLinkResponse.self
    )
  }
}

extension BetterAuthClient {
  public var magicLink: MagicLink {
    MagicLink(client: self)
  }

  @MainActor
  public class MagicLink {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient? = nil) {
      self.client = client
    }

    public typealias MagicLinkVerify = APIResource<
      MagicLinkVerifyResponse, EmptyContext
    >

    /// Make a request to **/magic-link/verify**
    /// - Parameter body: ``MagicLinkVerifyRequest``
    /// - Returns: ``MagicLinkVerify``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verify(with body: MagicLinkVerifyRequest) async throws
      -> MagicLinkVerify
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthMagicLinkRoute.magicLinkVerify,
          query: body,
          responseType: MagicLinkVerifyResponse.self
        )
      }
    }
  }
}
