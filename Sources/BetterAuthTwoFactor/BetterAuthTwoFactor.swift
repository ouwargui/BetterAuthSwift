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

    /// Makes a request to **/two-factor/enable**.
    ///
    /// - Parameter body: ``TwoFactorEnableRequest``
    /// - Returns: ``TwoFactorEnableResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func enable(with body: TwoFactorEnableRequest) async throws
      -> APIResource<TwoFactorEnableResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorEnable,
          body: body,
          responseType: TwoFactorEnableResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/disable**.
    ///
    /// - Parameter body: ``TwoFactorDisableRequest``
    /// - Returns: ``TwoFactorDisableResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func disable(with body: TwoFactorDisableRequest) async throws
      -> APIResource<TwoFactorDisableResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorDisableResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/generate-backup-codes**.
    ///
    /// - Parameter body: ``TwoFactorGenerateBackupCodesRequest``
    /// - Returns: ``TwoFactorGenerateBackupCodesResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func generateBackupCodes(
      with body: TwoFactorGenerateBackupCodesRequest
    ) async throws
      -> APIResource<TwoFactorGenerateBackupCodesResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorGenerateBackupCodesResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/get-totp-uri**.
    ///
    /// - Parameter body: ``TwoFactorGetTotpURIRequest``
    /// - Returns: ``TwoFactorGetTotpURIResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func getTotpURI(with body: TwoFactorGetTotpURIRequest) async throws
      -> APIResource<TwoFactorGetTotpURIResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorGetTotpURIResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/send-otp**.
    ///
    /// - Parameter body: ``TwoFactorSendOTPRequest``
    /// - Returns: ``TwoFactorSendOTPResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func sendOtp(with body: TwoFactorSendOTPRequest) async throws
      -> APIResource<TwoFactorSendOTPResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorSendOTPResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/verify-backup-code**.
    ///
    /// - Parameter body: ``TwoFactorVerifyBackupCodeRequest``
    /// - Returns: ``TwoFactorVerifyBackupCodeResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func verifyBackupCode(with body: TwoFactorVerifyBackupCodeRequest)
      async throws
      -> APIResource<TwoFactorVerifyBackupCodeResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorVerifyBackupCodeResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/verify-otp**.
    ///
    /// - Parameter body: ``TwoFactorVerifyOTPRequest``
    /// - Returns: ``TwoFactorVerifyOTPResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func verifyOtp(with body: TwoFactorVerifyOTPRequest) async throws
      -> APIResource<TwoFactorVerifyOTPResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorVerifyOTPResponse.self
        )
      }
    }

    /// Makes a request to **/two-factor/verify-totp**.
    ///
    /// - Parameter body: ``TwoFactorVerifyTOTPRequest``
    /// - Returns: ``TwoFactorVerifyTOTPResponse``
    /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
    public func verifyTotp(with body: TwoFactorVerifyTOTPRequest) async throws
      -> APIResource<TwoFactorVerifyTOTPResponse>
    {
      guard let client = self.client else {
        throw BetterAuthSwiftError(message: "Client deallocated")
      }

      return try await client.sessionStore.withSessionRefresh {
        return try await client.httpClient.request(
          route: BetterAuthTwoFactorRoute.twoFactorDisable,
          body: body,
          responseType: TwoFactorVerifyTOTPResponse.self
        )
      }
    }
  }
}
