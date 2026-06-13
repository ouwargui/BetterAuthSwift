import AuthenticationServices
import Foundation

#if !os(watchOS)
@MainActor
class OAuthHandler: NSObject {
  private var webAuthSession: ASWebAuthenticationSession?

  func extractScheme(from callbackURL: String?) throws -> String {
    guard let callbackURL = callbackURL,
      let url = URL(string: callbackURL),
      let scheme = url.scheme
    else {
      throw BetterAuthSwiftError(
        message:
          "Failed to create scheme from the callbackURL, received \(String(describing: callbackURL))"
      )
    }

    return scheme
  }

  func authenticate(authURL: String, callbackURLScheme: String) async throws
    -> String
  {
    return try await withCheckedThrowingContinuation {
      (continuation: CheckedContinuation<String, Error>) in
      guard let url = URL(string: authURL) else {
        continuation.resume(
          throwing: BetterAuthSwiftError(message: "Invalid auth URL")
        )
        return
      }

      let session = ASWebAuthenticationSession(
        url: url,
        callbackURLScheme: callbackURLScheme
      ) { @Sendable callbackURL, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else if let callbackURL = callbackURL,
          let cookie = OAuthHandler.extractCookieFromCallback(callbackURL)
        {
          continuation.resume(returning: cookie)
        } else {
          continuation.resume(
            throwing: BetterAuthSwiftError(
              message: "Failed to extract session cookie from callback URL"
            )
          )
        }
      }

      session.presentationContextProvider = self
      session.prefersEphemeralWebBrowserSession = false
      self.webAuthSession = session
      session.start()
    }
  }

  nonisolated private static func extractCookieFromCallback(_ callbackURL: URL)
    -> String?
  {
    guard
      let components = URLComponents(
        url: callbackURL,
        resolvingAgainstBaseURL: false
      ),
      let queryItems = components.queryItems
    else {
      return nil
    }

    return queryItems.first { $0.name == "cookie" }?.value
  }
}

extension OAuthHandler: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession)
    -> ASPresentationAnchor
  {
    #if os(iOS)
      return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    #elseif os(macOS)
      return NSApplication.shared.keyWindow ?? ASPresentationAnchor()
    #else
      return ASPresentationAnchor()
    #endif
  }
}
#endif
