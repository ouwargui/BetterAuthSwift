import BetterAuth
import Foundation

extension BetterAuthClient {
  public var twoFactor: TwoFactor {
    TwoFactor(client: self)
  }

  @MainActor
  public class TwoFactor {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public func enable(with body: TwoFactorEnableRequest) async throws
      -> TwoFactorEnableResponse
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorEnable,
          body: body,
          responseType: TwoFactorEnableResponse.self
        )
      }
    }

    public func disable(with body: TwoFactorDisableRequest) async throws
      -> TwoFactorDisableResponse
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorDisableResponse.self
        )
      }
    }
  }
}
