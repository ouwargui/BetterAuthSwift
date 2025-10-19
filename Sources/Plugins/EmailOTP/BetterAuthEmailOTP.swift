import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public typealias EmailOTPSignInEmailOTP = APIResource<
    EmailOTPSignInEmailOTPResponse, EmptyContext
  >

  /// Make a request to **/sign-in/email-otp**
  /// - Parameter body: ``EmailOTPSignInEmailOTPRequest``
  /// - Returns: ``EmailOTPSignInEmailOTP``
  /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
  public func emailOtp(with body: EmailOTPSignInEmailOTPRequest) async throws
    -> EmailOTPSignInEmailOTP {
    guard let client = client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.session.withSessionRefresh {
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
    self.pluginRegistry.get(id: EmailOTPPlugin.id)
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
    /// - Throws: ``/BetterAuth/BetterAuthApiError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func emailOtp(with body: EmailOTPForgetPasswordEmailOTPRequest)
      async throws -> EmailOTPForgetPasswordEmailOTP {
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
