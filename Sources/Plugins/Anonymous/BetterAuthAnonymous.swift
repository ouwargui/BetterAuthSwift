import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public typealias AnonymousSignInAnonymous = APIResource<
    AnonymousSignInAnonymousResponse, EmptyContext
  >

  /// Make a request to **/sign-in/anonymous**.
  /// - Returns: ``AnonymousSignInAnonymous``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func anonymous() async throws
    -> AnonymousSignInAnonymous
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await SignalBus.shared.emittingSignal(.signIn) {
      return try await client.httpClient.perform(
        route: BetterAuthAnonymousRoute.signInAnonymous,
        responseType: AnonymousSignInAnonymousResponse.self
      )
    }
  }
}
