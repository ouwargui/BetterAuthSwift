#if !os(watchOS)
  import BetterAuth
  import Foundation

  @available(iOS 15.0, macOS 12.0, *)
  public final class PasskeyPlugin: PluginFactory {
    public static let id = "passkey"

    public static func create(client: BetterAuthClient) -> Pluggable {
      Passkey(client: client)
    }

    public init() {}
  }

  @available(iOS 15.0, macOS 12.0, *)
  @MainActor
  public class Passkey: Pluggable {
    private weak var client: BetterAuthClient?

    /// Passkey store. Will be updated on passkey changes
    public let userPasskeys: PasskeyStore

    init(client: BetterAuthClient) {
      self.client = client
      self.userPasskeys = PasskeyStore(httpClient: client.httpClient)

      userPasskeys.objectWillChange
        .sink { [weak client] _ in client?.objectWillChange.send() }
        .store(in: &client.cancellables)
    }

    public typealias PasskeyAddPasskey = APIResource<
      PasskeyAddPasskeyResponse, EmptyContext
    >

    /// Handles the whole flow of adding a Passkey.
    ///
    /// Will call **/passkey/generate-register-options**. Then use `AuthenticationServices`
    /// to create a Passkey on the client and then verify it by calling **/passkey/verify-registration**.
    ///
    /// - Returns: ``PasskeyAddPasskey``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func addPasskey() async throws -> PasskeyAddPasskey {
      return try await self.addPasskey(with: .init())
    }

    /// Handles the whole flow of adding a Passkey.
    ///
    /// Will call **/passkey/generate-register-options**. Then use `AuthenticationServices`
    /// to create a Passkey on the client and then verify it by calling **/passkey/verify-registration**.
    ///
    /// - Parameter body: ``PasskeyAddPasskeyRequest``
    /// - Returns: ``PasskeyAddPasskey``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
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

      return try await client.passkey.verifyRegistration(
        with: .init(
          response: payload,
          name: body.name
        )
      )
    }

    public typealias PasskeyGenerateRegisterOptions = APIResource<
      PasskeyGenerateRegisterOptionsResponse, EmptyContext
    >

    /// Makes a request to **/passkey/generate-register-options**.
    ///
    /// - Parameter body: ``PasskeyGenerateRegisterOptionsRequest``
    /// - Returns: ``PasskeyGenerateRegisterOptions``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
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

    /// Makes a request to **/passkey/generate-authenticate-options**.
    ///
    /// - Parameter body: ``PasskeyGenerateAuthenticateOptionsRequest``
    /// - Returns: ``PasskeyGenerateAuthenticateOptions``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
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

    /// Makes a request to **/passkey/verify-registration**.
    ///
    /// - Parameter body: ``PasskeyVerifyRegistrationRequest``
    /// - Returns: ``PasskeyVerifyRegistration``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verifyRegistration(
      with body: PasskeyVerifyRegistrationRequest
    )
      async throws -> PasskeyVerifyRegistration
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await SignalBus.shared.emittingSignal(
        .passkeyVerifyRegistration
      ) {
        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyVerifyRegistration,
          body: body,
          responseType: PasskeyVerifyRegistrationResponse.self
        )
      }
    }

    public typealias PasskeyVerifyAuthentication = APIResource<
      PasskeyVerifyAuthenticationResponse, EmptyContext
    >

    /// Makes a request to **/passkey/verify-authentication**.
    ///
    /// - Parameter body: ``PasskeyVerifyAuthenticationRequest``
    /// - Returns: ``PasskeyVerifyAuthentication``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verifyAuthentication(
      with body: PasskeyVerifyAuthenticationRequest
    )
      async throws -> PasskeyVerifyAuthentication
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await SignalBus.shared.emittingSignal(
        .passkeyVerifyAuthentication
      ) {
        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyVerifyAuthentication,
          body: body,
          responseType: PasskeyVerifyAuthenticationResponse.self
        )
      }
    }

    public typealias PasskeyListUserPasskeys = APIResource<
      PasskeyListUserPasskeysResponse, EmptyContext
    >

    /// Makes a request to **/passkey/list-user-passkeys**.
    ///
    /// - Parameter body: ``PasskeyListUserPasskeysRequest``
    /// - Returns: ``PasskeyListUserPasskeys``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func listUserPasskeys() async throws -> PasskeyListUserPasskeys {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.httpClient.perform(
        route: BetterAuthPasskeyRoute.passkeyListUserPasskeys,
        responseType: PasskeyListUserPasskeysResponse.self
      )
    }

    public typealias PasskeyDeletePasskey = APIResource<
      PasskeyDeletePasskeyResponse, EmptyContext
    >

    /// Makes a request to **/passkey/delete-passkey**.
    ///
    /// - Parameter body: ``PasskeyDeletePasskeyRequest``
    /// - Returns: ``PasskeyDeletePasskey``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func deletePasskey(with body: PasskeyDeletePasskeyRequest)
      async throws -> PasskeyDeletePasskey
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await SignalBus.shared.emittingSignal(.passkeyDeletePasskey) {
        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyDeletePasskey,
          body: body,
          responseType: PasskeyDeletePasskeyResponse.self
        )
      }
    }

    public typealias PasskeyUpdatePasskey = APIResource<
      PasskeyUpdatePasskeyResponse, EmptyContext
    >

    /// Makes a request to **/passkey/update-passkey**.
    ///
    /// - Parameter body: ``PasskeyUpdatePasskeyRequest``
    /// - Returns: ``PasskeyUpdatePasskey``
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func updatePasskey(with body: PasskeyUpdatePasskeyRequest)
      async throws -> PasskeyUpdatePasskey
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await SignalBus.shared.emittingSignal(.passkeyDeletePasskey) {
        return try await client.httpClient.perform(
          route: BetterAuthPasskeyRoute.passkeyUpdatePasskey,
          body: body,
          responseType: PasskeyUpdatePasskeyResponse.self
        )
      }
    }
  }
#endif
