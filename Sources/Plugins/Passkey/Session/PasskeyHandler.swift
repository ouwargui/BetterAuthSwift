import AuthenticationServices
import BetterAuth
import Foundation

@available(iOS 15.0, *)
@MainActor
class PasskeyHandler: NSObject {
  private var authController: ASAuthorizationController?
  private var continuation: CheckedContinuation<ASAuthorization, Error>?

  func register(
    challenge: Data,
    userId: Data,
    username: String,
    userDisplayName: String,
    relyingPartyIdentifier: String
  ) async throws -> ASAuthorizationPlatformPublicKeyCredentialRegistration {
    let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
      relyingPartyIdentifier: relyingPartyIdentifier
    )

    let request = provider.createCredentialRegistrationRequest(
      challenge: challenge,
      name: username,
      userID: userId
    )

    let authorization = try await self.performRequest(request)

    guard
      let credential = authorization.credential
        as? ASAuthorizationPlatformPublicKeyCredentialRegistration
    else {
      throw BetterAuthSwiftError(
        message: "Invalid credential type for registration"
      )
    }

    return credential
  }

  func authenticate(
    challenge: Data,
    relyingPartyIdentifier: String,
    allowedCredentials: [Data]? = nil
  ) async throws -> ASAuthorizationPublicKeyCredentialAssertion {
    let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
      relyingPartyIdentifier: relyingPartyIdentifier
    )

    let request = provider.createCredentialAssertionRequest(
      challenge: challenge
    )

    if let allowedCredentials = allowedCredentials {
      request.allowedCredentials = allowedCredentials.map { credentialId in
        ASAuthorizationPlatformPublicKeyCredentialDescriptor(
          credentialID: credentialId
        )
      }
    }

    let authorization = try await performRequest(request)

    guard
      let credential = authorization.credential
        as? ASAuthorizationPlatformPublicKeyCredentialAssertion
    else {
      throw BetterAuthSwiftError(
        message: "Invalid credential type for authentication"
      )
    }

    return credential
  }

  private func performRequest(_ request: ASAuthorizationRequest) async throws
    -> ASAuthorization
  {
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation

      authController = ASAuthorizationController(authorizationRequests: [
        request
      ])
      authController?.delegate = self
      authController?.presentationContextProvider = self
      authController?.performRequests()
    }
  }
}

@available(iOS 15.0, *)
extension PasskeyHandler: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    continuation?.resume(returning: authorization)
    cleanup()
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: any Error
  ) {
    continuation?.resume(throwing: error)
    cleanup()
  }

  private func cleanup() {
    authController = nil
    continuation = nil
  }
}

@available(iOS 15.0, *)
extension PasskeyHandler: ASAuthorizationControllerPresentationContextProviding
{
  func presentationAnchor(for controller: ASAuthorizationController)
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
