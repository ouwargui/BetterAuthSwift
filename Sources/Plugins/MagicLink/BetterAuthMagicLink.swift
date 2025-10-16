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
    self.pluginRegistry.get(id: MagicLinkPlugin.id)
  }
}
