import BetterAuth
import Foundation

public final class PhoneNumberPlugin: PluginFactory {
  public static let id: String = "phoneNumber"
  public static func create(client: BetterAuthClient) -> Pluggable {
    PhoneNumber()
  }

  public init() {}
}

@MainActor
public final class PhoneNumber: Pluggable {
  private weak var client: BetterAuthClient?

  init(client: BetterAuthClient? = nil) {
    self.client = client
  }

  public typealias PhoneNumberSendOTP = APIResource<
    PhoneNumberSendOTPResponse, EmptyContext
  >

  /// Make a request to **/phone-number/send-otp**.
  /// - Parameter body: ``PhoneNumberSendOTPRequest``
  /// - Returns: ``PhoneNumberSendOTP``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func sendOtp(with body: PhoneNumberSendOTPRequest) async throws
    -> PhoneNumberSendOTP {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthPhoneNumberRoute.phoneNumberSendOTP,
      body: body,
      responseType: PhoneNumberSendOTPResponse.self
    )
  }

  public typealias PhoneNumberVerify = APIResource<
    PhoneNumberVerifyResponse, EmptyContext
  >

  /// Make a request to **/phone-number/verify**.
  /// - Parameter body: ``PhoneNumberVerifyRequest``
  /// - Returns: ``PhoneNumberVerify``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func verify(with body: PhoneNumberVerifyRequest) async throws
    -> PhoneNumberVerify {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.session.withSessionRefresh {
      return try await client.httpClient.perform(
        route: BetterAuthPhoneNumberRoute.phoneNumberVerify,
        body: body,
        responseType: PhoneNumberVerifyResponse.self
      )
    }
  }

  public typealias PhoneNumberForgetPassword = APIResource<
    PhoneNumberForgetPasswordResponse, EmptyContext
  >

  /// Make a request to **/phone-number/forget-password**.
  /// - Parameter body: ``PhoneNumberForgetPasswordRequest``
  /// - Returns: ``PhoneNumberForgetPassword``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func forgetPassword(with body: PhoneNumberForgetPasswordRequest)
    async throws
    -> PhoneNumberForgetPassword {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthPhoneNumberRoute.phoneNumberForgetPassword,
      body: body,
      responseType: PhoneNumberForgetPasswordResponse.self
    )
  }

  public typealias PhoneNumberRequestPasswordReset = APIResource<
    PhoneNumberRequestPasswordResetResponse, EmptyContext
  >

  /// Make a request to **/phone-number/request-password-reset**.
  /// - Parameter body: ``PhoneNumberRequestPasswordResetRequest``
  /// - Returns: ``PhoneNumberRequestPasswordReset``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func requestPasswordReset(
    with body: PhoneNumberRequestPasswordResetRequest
  )
    async throws
    -> PhoneNumberRequestPasswordReset {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthPhoneNumberRoute.phoneNumberRequestPasswordReset,
      body: body,
      responseType: PhoneNumberRequestPasswordResetResponse.self
    )
  }

  public typealias PhoneNumberResetPassword = APIResource<
    PhoneNumberResetPasswordResponse, EmptyContext
  >

  /// Make a request to **/phone-number/reset-password**.
  /// - Parameter body: ``PhoneNumberResetPasswordRequest``
  /// - Returns: ``PhoneNumberResetPassword``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func resetPassword(
    with body: PhoneNumberResetPasswordRequest
  )
    async throws
    -> PhoneNumberResetPassword {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthPhoneNumberRoute.phoneNumberResetPassword,
      body: body,
      responseType: PhoneNumberResetPasswordResponse.self
    )
  }
}
