import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public typealias EmailOTPSignInEmailOTP = APIResource<
    EmailOTPSignInEmailOTPResponse, EmptyContext
  >

  /// Make a request to **/sign-in/email-otp**
  /// - Parameter body: ``EmailOTPSignInEmailOTPRequest``
  /// - Returns: ``EmailOTPSignInEmailOTP``
  /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func emailOtp(with body: EmailOTPSignInEmailOTPRequest) async throws
    -> EmailOTPSignInEmailOTP
  {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.perform(
        route: BetterAuthEmailOTPRoute.signInEmailOTP,
        body: body,
        responseType: EmailOTPSignInEmailOTPResponse.self
      )
    }
  }
}

extension BetterAuthClient {
  public var emailOtp: EmailOTP {
    EmailOTP(client: self)
  }

  public class EmailOTP {
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
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
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
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
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
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verifyEmail(
      with body: EmailOTPVerifyEmailRequest
    ) async throws -> EmailOTPVerifyEmail {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
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
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
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
}

extension BetterAuthClient {
  public var forgetPassword: ForgetPasswordClass {
    ForgetPasswordClass(client: self)
  }

  public class ForgetPasswordClass {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient? = nil) {
      self.client = client
    }

    public typealias EmailOTPForgetPasswordEmailOTP = APIResource<
      EmailOTPForgetPasswordEmailOTPResponse, EmptyContext
    >

    /// Make a request to **/forget-password/email-otp**
    /// - Parameter body: ``EmailOTPForgetPasswordEmailOTPRequest``
    /// - Returns: ``EmailOTPForgetPasswordEmailOTP``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func emailOtp(with body: EmailOTPForgetPasswordEmailOTPRequest)
      async throws -> EmailOTPForgetPasswordEmailOTP
    {
      guard let client = client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.httpClient.perform(
        route: BetterAuthEmailOTPRoute.forgetPasswordEmailOTP,
        body: body,
        responseType: EmailOTPForgetPasswordEmailOTPResponse.self
      )
    }
  }
}
