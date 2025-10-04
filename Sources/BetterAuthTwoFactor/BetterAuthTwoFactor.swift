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

    /// Makes a request to **/two-factor/enable**.
    ///
    /// - Parameter body: ``TwoFactorEnableRequest``
    /// - Returns: ``TwoFactorEnableResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/disable**.
    ///
    /// - Parameter body: ``TwoFactorDisableRequest``
    /// - Returns: ``TwoFactorDisableResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/generate-backup-codes**.
    ///
    /// - Parameter body: ``TwoFactorGenerateBackupCodesRequest``
    /// - Returns: ``TwoFactorGenerateBackupCodesResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/get-totp-uri**.
    ///
    /// - Parameter body: ``TwoFactorGetTotpURIRequest``
    /// - Returns: ``TwoFactorGetTotpURIResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/send-otp**.
    ///
    /// - Parameter body: ``TwoFactorSendOTPRequest``
    /// - Returns: ``TwoFactorSendOTPResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/verify-backup-code**.
    ///
    /// - Parameter body: ``TwoFactorVerifyBackupCodeRequest``
    /// - Returns: ``TwoFactorVerifyBackupCodeResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/verify-otp**.
    ///
    /// - Parameter body: ``TwoFactorVerifyOTPRequest``
    /// - Returns: ``TwoFactorVerifyOTPResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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

    /// Makes a request to **/two-factor/verify-totp**.
    ///
    /// - Parameter body: ``TwoFactorVerifyTOTPRequest``
    /// - Returns: ``TwoFactorVerifyTOTPResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
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
