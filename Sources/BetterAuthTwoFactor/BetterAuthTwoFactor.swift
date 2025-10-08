import BetterAuth
import Foundation

extension BetterAuthClient {
  public var twoFactor: TwoFactor {
    TwoFactor(client: self)
  }

  @MainActor
  public class TwoFactor {
    private weak var client: BetterAuthClient?

    init(client: BetterAuthClient) {
      self.client = client
    }

    public typealias TwoFactorEnable = APIResource<
      TwoFactorEnableResponse, EmptyContext
    >

    /// Make a request to **/two-factor/enable**.
    /// - Parameter body: ``TwoFactorEnableRequest``
    /// - Returns: ``TwoFactorEnable``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func enable(with body: TwoFactorEnableRequest) async throws
      -> TwoFactorEnable
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.enable,
          body: body,
          responseType: TwoFactorEnableResponse.self
        )
      }
    }

    public typealias TwoFactorDisable = APIResource<
      TwoFactorDisableResponse, EmptyContext
    >

    /// Make a request to **/two-factor/disable**.
    /// - Parameter body: ``TwoFactorDisableRequest``
    /// - Returns: ``TwoFactorDisable``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func disable(with body: TwoFactorDisableRequest) async throws
      -> TwoFactorDisable
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.disable,
          body: body,
          responseType: TwoFactorDisableResponse.self
        )
      }
    }

    public typealias TwoFactorGenerateBackupCodes = APIResource<
      TwoFactorGenerateBackupCodesResponse, EmptyContext
    >

    /// Make a request to **/two-factor/generate-backup-codes**.
    /// - Parameter body: ``TwoFactorGenerateBackupCodesRequest``
    /// - Returns: ``TwoFactorGenerateBackupCodes``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func generateBackupCodes(
      with body: TwoFactorGenerateBackupCodesRequest
    ) async throws
      -> TwoFactorGenerateBackupCodes
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.generateBackupCodes,
          body: body,
          responseType: TwoFactorGenerateBackupCodesResponse.self
        )
      }
    }

    public typealias TwoFactorGetTotpURI = APIResource<
      TwoFactorGetTotpURIResponse, EmptyContext
    >

    /// Make a request to **/two-factor/get-totp-uri**.
    /// - Parameter body: ``TwoFactorGetTotpURIRequest``
    /// - Returns: ``TwoFactorGetTotpURI``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func getTotpURI(with body: TwoFactorGetTotpURIRequest) async throws
      -> TwoFactorGetTotpURI
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.getTotpURI,
          body: body,
          responseType: TwoFactorGetTotpURIResponse.self
        )
      }
    }

    public typealias TwoFactorSendOTP = APIResource<
      TwoFactorSendOTPResponse, EmptyContext
    >

    /// Make a request to **/two-factor/send-otp**.
    /// - Parameter body: ``TwoFactorSendOTPRequest``
    /// - Returns: ``TwoFactorSendOTP``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func sendOtp(with body: TwoFactorSendOTPRequest) async throws
      -> TwoFactorSendOTP
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.sendOTP,
          body: body,
          responseType: TwoFactorSendOTPResponse.self
        )
      }
    }

    public typealias TwoFactorVerifyBackupCode = APIResource<
      TwoFactorVerifyBackupCodeResponse, EmptyContext
    >

    /// Make a request to **/two-factor/verify-backup-code**.
    /// - Parameter body: ``TwoFactorVerifyBackupCodeRequest``
    /// - Returns: ``TwoFactorVerifyBackupCode``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verifyBackupCode(with body: TwoFactorVerifyBackupCodeRequest)
      async throws
      -> TwoFactorVerifyBackupCode
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.verifyBackupCode,
          body: body,
          responseType: TwoFactorVerifyBackupCodeResponse.self
        )
      }
    }

    public typealias TwoFactorVerifyOTP = APIResource<
      TwoFactorVerifyOTPResponse, EmptyContext
    >

    /// Make a request to **/two-factor/verify-otp**.
    /// - Parameter body: ``TwoFactorVerifyOTPRequest``
    /// - Returns: ``TwoFactorVerifyOTP``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verifyOtp(with body: TwoFactorVerifyOTPRequest) async throws
      -> TwoFactorVerifyOTP
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.verifyOTP,
          body: body,
          responseType: TwoFactorVerifyOTPResponse.self
        )
      }
    }

    public typealias TwoFactorVerifyTOTP = APIResource<
      TwoFactorVerifyTOTPResponse, EmptyContext
    >

    /// Make a request to **/two-factor/verify-totp**.
    /// - Parameter body: ``TwoFactorVerifyTOTPRequest``
    /// - Returns: ``TwoFactorVerifyTOTP``
    /// - Throws: ``/BetterAuth/BetterAuthError`` - ``/BetterAuth/BetterAuthSwiftError``
    public func verifyTotp(with body: TwoFactorVerifyTOTPRequest) async throws
      -> TwoFactorVerifyTOTP
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.perform(
          route: BetterAuthTwoFactorRoute.verifyTOTP,
          body: body,
          responseType: TwoFactorVerifyTOTPResponse.self
        )
      }
    }
  }
}
