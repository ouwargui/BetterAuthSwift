import BetterAuth
import Foundation

extension BetterAuthClient {
  public var phoneNumber: PhoneNumber {
    PhoneNumber(client: self)
  }

  @MainActor
  public class PhoneNumber {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient? = nil) {
      self.client = client
    }

    public typealias PhoneNumberSendOTP = APIResource<
      PhoneNumberSendOTPResponse, EmptyContext
    >

    public func sendOtp(with body: PhoneNumberSendOTPRequest) async throws
      -> PhoneNumberSendOTP
    {
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

    public func verify(with body: PhoneNumberVerifyRequest) async throws
      -> PhoneNumberVerify
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
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

    public func forgetPassword(with body: PhoneNumberForgetPasswordRequest)
      async throws
      -> PhoneNumberForgetPassword
    {
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

    public func requestPasswordReset(
      with body: PhoneNumberRequestPasswordResetRequest
    )
      async throws
      -> PhoneNumberRequestPasswordReset
    {
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

    public func resetPassword(
      with body: PhoneNumberResetPasswordRequest
    )
      async throws
      -> PhoneNumberResetPassword
    {
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
}

extension BetterAuthClient.SignIn {
  public typealias PhoneNumberSignInPhoneNumber = APIResource<
    PhoneNumberSignInPhoneNumberResponse, EmptyContext
  >

  public func phoneNumber(with body: PhoneNumberSignInPhoneNumberRequest)
    async throws -> PhoneNumberSignInPhoneNumber
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.perform(
        route: BetterAuthPhoneNumberRoute.signInPhoneNumber,
        body: body,
        responseType: PhoneNumberSignInPhoneNumberResponse.self
      )
    }
  }
}
