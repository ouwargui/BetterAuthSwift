import Foundation
import AuthenticationServices

class OAuthHandler: NSObject {
  private var webAuthSession: ASWebAuthenticationSession?
  private var completion: ((Result<URL, Error>) -> Void)?
  
  func extractScheme(from callbackURL: String?) throws -> String {
    guard let callbackURL = callbackURL,
          let url = URL(string: callbackURL),
          let scheme = url.scheme else {
      throw BetterAuthSwiftError(message: "Failed to create scheme from the callbackURL, received \(callbackURL)")
    }
    
    return scheme
  }
  
  func authenticate(authURL: String, callbackURLScheme: String) async throws -> URL {
    return try await withCheckedThrowingContinuation { continuation in
      self.completion = { result in
        continuation.resume(with: result)
      }
      
      guard let url = URL(string: authURL) else {
        continuation.resume(throwing: BetterAuthSwiftError(message: "Invalid auth URL"))
        return
      }
      
      webAuthSession = .init(
        url: url,
        callbackURLScheme: callbackURLScheme
      ) { [weak self] callbackURL, error in
        if let error = error {
          self?.completion?(.failure(error))
        } else if let callbackURL = callbackURL {
          self?.completion?(.success(callbackURL))
        } else {
          self?.completion?(.failure(BetterAuthSwiftError(message: "No callback URL received")))
        }
        
        self?.webAuthSession = nil
        self?.completion = nil
      }
      
      webAuthSession?.presentationContextProvider = self
      webAuthSession?.prefersEphemeralWebBrowserSession = false
      print(webAuthSession?.canStart)
    }
  }
}

extension OAuthHandler: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
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
