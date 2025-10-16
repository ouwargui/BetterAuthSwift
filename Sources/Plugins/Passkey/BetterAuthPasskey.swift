#if !os(watchOS)
  import BetterAuth
  import Foundation

  @available(iOS 15.0, macOS 12.0, *)
  extension BetterAuthClient.SignIn {
    public typealias PasskeySignInPasskey = APIResource<
      PasskeySignInPasskeyResponse, EmptyContext
    >

    public func passkey() async throws -> PasskeySignInPasskey {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      let authOptions = try await client.passkey.generateAuthenticateOptions()

      guard let challenge = Data(base64urlEncoded: authOptions.data.challenge)
      else {
        throw BetterAuthSwiftError(
          message: "Failed to encode challenge to Data"
        )
      }

      let allowedCredentials = authOptions.data.allowCredentials?
        .compactMap {
          $0.id.data(using: .utf8)
        }

      let handler = PasskeyHandler()
      let authResult = try await handler.authenticate(
        challenge: challenge,
        relyingPartyIdentifier: client.baseUrl.hostname,
        allowedCredentials: allowedCredentials
      )

      let response = PasskeyAuthenticatorAssertionResponse(
        clientDataJSON: authResult.rawClientDataJSON.base64urlEncodedString(),
        authenticatorData: authResult.rawAuthenticatorData
          .base64urlEncodedString(),
        signature: authResult.signature.base64urlEncodedString()
      )

      let passkeyResponse = PasskeyAuthenticationResponse(
        id: authResult.credentialID.base64urlEncodedString(),
        rawId: authResult.credentialID.base64urlEncodedString(),
        response: response,
        clientExtensionResults: .init(),
        type: .publicKey
      )

      return try await client.passkey.verifyAuthentication(
        with: .init(response: passkeyResponse)
      )
    }

    #if os(iOS) || os(visionOS)
      @available(iOS 16.0, *)
      public func passkeyAutoFill() async throws
        -> PasskeySignInPasskey
      {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        let authOptions = try await client.passkey.generateAuthenticateOptions()

        guard let challenge = Data(base64urlEncoded: authOptions.data.challenge)
        else {
          throw BetterAuthSwiftError(
            message: "Failed to encode challenge to Data"
          )
        }

        let allowedCredentials = authOptions.data.allowCredentials?
          .compactMap {
            $0.id.data(using: .utf8)
          }

        let handler = PasskeyHandler()
        let authResult = try await handler.authenticateWithAutoFill(
          challenge: challenge,
          relyingPartyIdentifier: client.baseUrl.hostname,
          allowedCredentials: allowedCredentials
        )

        let response = PasskeyAuthenticatorAssertionResponse(
          clientDataJSON: authResult.rawClientDataJSON.base64urlEncodedString(),
          authenticatorData: authResult.rawAuthenticatorData
            .base64urlEncodedString(),
          signature: authResult.signature.base64urlEncodedString()
        )

        let passkeyResponse = PasskeyAuthenticationResponse(
          id: authResult.credentialID.base64urlEncodedString(),
          rawId: authResult.credentialID.base64urlEncodedString(),
          response: response,
          clientExtensionResults: .init(),
          type: .publicKey
        )

        return try await client.sessionStore.withSessionRefresh {
          return try await client.httpClient.perform(
            route: BetterAuthPasskeyRoute.passkeyVerifyAuthentication,
            body: passkeyResponse,
            responseType: PasskeyVerifyAuthenticationResponse.self
          )
        }
      }
    #endif
  }

  @available(iOS 15.0, macOS 12.0, *)
  extension BetterAuthClient {
    public var passkey: Passkey {
      self.pluginRegistry.get(id: PasskeyPlugin.id)
    }
  }
#endif
