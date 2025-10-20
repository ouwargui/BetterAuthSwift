import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public typealias PhoneNumberSignInPhoneNumber = APIResource<
    PhoneNumberSignInPhoneNumberResponse, EmptyContext
  >

  /// Make a request to **/sign-in/phone-number**.
  /// - Parameter body: ``PhoneNumberSignInPhoneNumberRequest``
  /// - Returns: ``PhoneNumberSignInPhoneNumber``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func phoneNumber(with body: PhoneNumberSignInPhoneNumberRequest)
    async throws -> PhoneNumberSignInPhoneNumber
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await SignalBus.shared.emittingSignal(.signIn) {
      return try await client.httpClient.perform(
        route: BetterAuthPhoneNumberRoute.signInPhoneNumber,
        body: body,
        responseType: PhoneNumberSignInPhoneNumberResponse.self
      )
    }
  }
}

extension BetterAuthClient {
  public var phoneNumber: PhoneNumber {
    self.pluginRegistry.get(id: PhoneNumberPlugin.id)
  }
}
