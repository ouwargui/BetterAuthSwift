import BetterAuth
import Foundation

public final class MagicLinkPlugin: PluginFactory {
  public static let id: String = "magicLink"
  public static func create(client: BetterAuthClient) -> Pluggable {
    MagicLink()
  }

  public init() {}
}

@MainActor
public final class MagicLink: Pluggable {
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
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func verify(with body: MagicLinkVerifyRequest) async throws
    -> MagicLinkVerify
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await SignalBus.shared.emittingSignal(.magicLinkVerify) {
      return try await client.httpClient.perform(
        route: BetterAuthMagicLinkRoute.magicLinkVerify,
        query: body,
        responseType: MagicLinkVerifyResponse.self
      )
    }
  }
}
