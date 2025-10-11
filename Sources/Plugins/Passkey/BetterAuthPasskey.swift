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

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyVerifyAuthentication,
          body: passkeyResponse,
          responseType: PasskeyVerifyAuthenticationResponse.self
        )
      }
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
      Passkey(client: self)
    }

    @MainActor
    public class Passkey {
      private weak var client: BetterAuthClient?

      init(client: BetterAuthClient) {
        self.client = client
      }

      public typealias PasskeyAddPasskey = APIResource<
        PasskeyAddPasskeyResponse, EmptyContext
      >

      public func addPasskey() async throws -> PasskeyAddPasskey {
        return try await self.addPasskey(with: .init())
      }
      public func addPasskey(with body: PasskeyAddPasskeyRequest) async throws
        -> PasskeyAddPasskey
      {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        let regOptions = try await self.generateRegisterOptions(
          with: .init(
            name: body.name,
            authenticatorAttachment: body.authenticatorAttachment
          )
        )

        guard let userId = regOptions.data.user.id.data(using: .utf8),
          let challenge = Data(base64urlEncoded: regOptions.data.challenge)
        else {
          throw BetterAuthSwiftError(
            message: "Failed to encode userId and challenge to Data"
          )
        }

        let handler = PasskeyHandler()
        let regResult = try await handler.register(
          challenge: challenge,
          userId: userId,
          username: regOptions.data.user.name,
          userDisplayName: regOptions.data.user.displayName,
          relyingPartyIdentifier: client.baseUrl.hostname
        )

        let response = PasskeyAuthenticatorAttestationResponse(
          clientDataJSON: regResult.rawClientDataJSON.base64urlEncodedString(),
          attestationObject: regResult.rawAttestationObject?
            .base64urlEncodedString(),
        )

        let clientExtensionResults =
          PasskeyAuthenticationExtensionsClientOutputs()

        let payload = PasskeyRegistrationResponse(
          id: regResult.credentialID.base64urlEncodedString(),
          rawId: regResult.credentialID.base64urlEncodedString(),
          response: response,
          authenticatorAttachment: body.authenticatorAttachment,
          clientExtensionResults: clientExtensionResults,
          type: .publicKey
        )

        let verify = try await client.passkey.verifyRegistration(
          with: .init(
            response: payload,
            name: body.name
          )
        )

        return verify
      }

      public typealias PasskeyGenerateRegisterOptions = APIResource<
        PasskeyGenerateRegisterOptionsResponse, EmptyContext
      >

      public func generateRegisterOptions(
        with body: PasskeyGenerateRegisterOptionsRequest
      ) async throws -> PasskeyGenerateRegisterOptions {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyGenerateRegisterOptions,
          query: body,
          responseType: PasskeyGenerateRegisterOptionsResponse.self
        )
      }

      public typealias PasskeyGenerateAuthenticateOptions = APIResource<
        PasskeyGenerateAuthenticateOptionsResponse, EmptyContext
      >

      public func generateAuthenticateOptions() async throws
        -> PasskeyGenerateAuthenticateOptions
      {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyGenerateAuthenticateOptions,
          responseType: PasskeyGenerateAuthenticateOptionsResponse.self
        )
      }

      public typealias PasskeyVerifyRegistration = APIResource<
        PasskeyVerifyRegistrationResponse, EmptyContext
      >

      public func verifyRegistration(
        with body: PasskeyVerifyRegistrationRequest
      )
        async throws -> PasskeyVerifyRegistration
      {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyVerifyRegistration,
          body: body,
          responseType: PasskeyVerifyRegistrationResponse.self
        )
      }

      public typealias PasskeyVerifyAuthentication = APIResource<
        PasskeyVerifyAuthenticationResponse, EmptyContext
      >

      public func verifyAuthentication(
        with body: PasskeyVerifyAuthenticationRequest
      )
        async throws -> PasskeyVerifyAuthentication
      {
        guard let client = client else {
          throw BetterAuthSwiftError(message: "Client deallocated")
        }

        return try await client.sessionStore.withSessionRefresh {
          return try await client.httpClient.perform(
            route: BetterAuthPasskeyRoute.passkeyVerifyAuthentication,
            body: body,
            responseType: PasskeyVerifyAuthenticationResponse.self
          )
        }
      }
    }
  }
#endif
