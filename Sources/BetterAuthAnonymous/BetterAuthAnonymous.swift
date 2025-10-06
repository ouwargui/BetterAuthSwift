import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public typealias AnonymousSignInAnonymous = APIResource<
    AnonymousSignInAnonymousResponse, EmptyContext
  >

  public func anonymous() async throws
    -> AnonymousSignInAnonymous
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.perform(
        route: BetterAuthAnonymousRoute.signInAnonymous,
        responseType: AnonymousSignInAnonymousResponse.self
      )
    }
  }
}
