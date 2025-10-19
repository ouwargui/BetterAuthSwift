import BetterAuth
import Foundation

public final class EmailOTPPlugin: PluginFactory {
  public static let id: String = "email-otp"
  public static func create(client: BetterAuthClient) -> Pluggable {
    EmailOTP()
  }

  public init() {}
}

@MainActor
public final class EmailOTP: Pluggable {
  private weak var client: BetterAuthClient?

  init(client: BetterAuthClient? = nil) {
    self.client = client
  }

  public typealias EmailOTPSendVerificationOTP = APIResource<
    EmailOTPSendVerificationOTPResponse, EmptyContext
  >

  /// Make a request to **/email-otp/send-verification-otp**
  /// - Parameter body: ``EmailOTPSendVerificationOTPRequest``
  /// - Returns: ``EmailOTPSendVerificationOTP``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func sendVerificationOtp(
    with body: EmailOTPSendVerificationOTPRequest
  ) async throws -> EmailOTPSendVerificationOTP {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthEmailOTPRoute.emailOTPSendVerificationOTP,
      body: body,
      responseType: EmailOTPSendVerificationOTPResponse.self
    )
  }

  public typealias EmailOTPCheckVerificationOTP = APIResource<
    EmailOTPCheckVerificationOTPResponse, EmptyContext
  >

  /// Make a request to **/email-otp/check-verification-otp**
  /// - Parameter body: ``EmailOTPCheckVerificationOTPRequest``
  /// - Returns: ``EmailOTPCheckVerificationOTP``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func checkVerificationOtp(
    with body: EmailOTPCheckVerificationOTPRequest
  ) async throws -> EmailOTPCheckVerificationOTP {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthEmailOTPRoute.emailOTPCheckVerificationOTP,
      body: body,
      responseType: EmailOTPCheckVerificationOTPResponse.self
    )
  }

  public typealias EmailOTPVerifyEmail = APIResource<
    EmailOTPVerifyEmailResponse, EmptyContext
  >

  /// Make a request to **/email-otp/verify-email**
  /// - Parameter body: ``EmailOTPVerifyEmailRequest``
  /// - Returns: ``EmailOTPVerifyEmail``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func verifyEmail(
    with body: EmailOTPVerifyEmailRequest
  ) async throws -> EmailOTPVerifyEmail {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.session.withSessionRefresh {
      return try await client.httpClient.perform(
        route: BetterAuthEmailOTPRoute.emailOTPVerifyEmail,
        body: body,
        responseType: EmailOTPVerifyEmailResponse.self
      )
    }
  }

  public typealias EmailOTPResetPassword = APIResource<
    EmailOTPResetPasswordResponse, EmptyContext
  >

  /// Make a request to **/email-otp/reset-password**
  /// - Parameter body: ``EmailOTPResetPasswordRequest``
  /// - Returns: ``EmailOTPResetPassword``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func resetPassword(
    with body: EmailOTPResetPasswordRequest
  ) async throws -> EmailOTPResetPassword {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.perform(
      route: BetterAuthEmailOTPRoute.emailOTPResetPassword,
      body: body,
      responseType: EmailOTPResetPasswordResponse.self
    )
  }
}
