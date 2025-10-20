#if !os(watchOS)
  import AuthenticationServices
  import BetterAuth
  import Foundation

  @available(iOS 15.0, macOS 12.0, *)
  @MainActor
  class PasskeyHandler: NSObject {
    public static let shared = PasskeyHandler()
    private var authController: ASAuthorizationController?
    private var continuation: CheckedContinuation<ASAuthorization, Error>?
    private var autoFillContinuation: CheckedContinuation<Void, Never>?

    private override init() {}

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

    private func createAuthenticateRequest(
      challenge: Data,
      relyingPartyIdentifier: String,
      allowedCredentials: [Data]? = nil,
    ) -> ASAuthorizationPlatformPublicKeyCredentialAssertionRequest {
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

      return request
    }

    #if os(iOS) || os(visionOS)
      @available(iOS 16.0, *)
      func authenticateWithAutoFill(
        challenge: Data,
        relyingPartyIdentifier: String,
        allowedCredentials: [Data]? = nil,
      ) async throws -> ASAuthorizationPublicKeyCredentialAssertion {
        let request = self.createAuthenticateRequest(
          challenge: challenge,
          relyingPartyIdentifier: relyingPartyIdentifier,
          allowedCredentials: allowedCredentials
        )

        let authorization = try await performAutoFillAssistedRequest(request)

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
    #endif

    func authenticate(
      challenge: Data,
      relyingPartyIdentifier: String,
      allowedCredentials: [Data]? = nil,
    ) async throws -> ASAuthorizationPublicKeyCredentialAssertion {
      let request = self.createAuthenticateRequest(
        challenge: challenge,
        relyingPartyIdentifier: relyingPartyIdentifier,
        allowedCredentials: allowedCredentials
      )

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

    private func performRequest(
      _ request: ASAuthorizationRequest,
    ) async throws
      -> ASAuthorization
    {
      if #available(iOS 16.0, macOS 13.0, *) {
        await self.cancelAutofill()
      }

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

    #if os(iOS) || os(visionOS)
      @available(iOS 16.0, *)
      private func performAutoFillAssistedRequest(
        _ request: ASAuthorizationRequest
      )
        async throws -> ASAuthorization
      {
        await self.cancelAutofill()

        return try await withCheckedThrowingContinuation { continuation in
          self.continuation = continuation

          authController = ASAuthorizationController(authorizationRequests: [
            request
          ])
          authController?.delegate = self
          authController?.presentationContextProvider = self
          authController?.performAutoFillAssistedRequests()
        }
      }
    #endif
  }

  @available(iOS 15.0, macOS 12.0, *)
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
      autoFillContinuation?.resume(returning: ())
      cleanup()
    }

    private func cleanup() {
      authController = nil
      autoFillContinuation = nil
      continuation = nil
    }

    @available(iOS 16.0, macOS 13.0, *)
    private func cancelAutofill() async {
      return await withCheckedContinuation { continuation in
        if let autoFillContinuation = self.autoFillContinuation {
          autoFillContinuation.resume(returning: ())
          self.autoFillContinuation = nil
        }

        guard let controller = self.authController else {
          continuation.resume()
          return
        }

        self.autoFillContinuation = continuation
        controller.cancel()
      }
    }
  }

  @available(iOS 15.0, macOS 12.0, *)
  extension PasskeyHandler:
    ASAuthorizationControllerPresentationContextProviding
  {
    package func presentationAnchor(for controller: ASAuthorizationController)
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
