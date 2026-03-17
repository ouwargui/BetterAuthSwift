import BetterAuth
import Foundation

public final class GenericOAuthPlugin: PluginFactory {
  public static let id: String = "genericOAuth"

  public static func create(client: BetterAuthClient) -> Pluggable {
    GenericOAuth(client: client)
  }

  public init() {}
}

@MainActor
public final class GenericOAuth: Pluggable {
  private weak var client: BetterAuthClient?

  public init(client: BetterAuthClient) {
    self.client = client
  }

  public typealias GenericOAuthLink = APIResource<
    GenericOAuthLinkResponse, EmptyContext
  >

  /// Make a request to **/oauth2/link**.
  /// - Parameter body: ``GenericOAuthLinkRequest``
  /// - Returns: ``GenericOAuthLink``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func link(with body: GenericOAuthLinkRequest) async throws
    -> GenericOAuthLink
  {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthGenericOAuthRoute.oauth2Link,
      body: body,
      responseType: GenericOAuthLinkResponse.self
    )
  }

  public func makeAuthorizationProxyURL(for authorizationURL: String) throws -> URL {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    var components = URLComponents(
      url: client.baseUrl,
      resolvingAgainstBaseURL: false
    )
    components?.path.append(BetterAuthRoute.expoAuthorizationProxy.path)
    components?.queryItems = [
      URLQueryItem(
        name: "authorizationURL",
        value: authorizationURL
      )
    ]

    guard let url = components?.url else {
      throw BetterAuthSwiftError(message: "Failed to create proxy URL")
    }

    return url
  }
}
