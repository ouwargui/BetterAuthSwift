import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  /// Makes a request to **/sign-in/email**.
  ///
  ///  When using the Two Factor plugin, you'll need to add a type annotation to the variable you're assigning the result to.
  ///
  ///  ```swift
  ///  let res: TwoFactorSignInEmailResponse = client.signIn.email(with: body)
  ///  ```
  ///
  /// - Parameter body: ``SignInEmailRequest``
  /// - Returns: ``TwoFactorSignInEmailResponse``
  /// - Throws: ``BetterAuthError`` - ``BetterAuthSwiftError``
  public func email(with body: SignInEmailRequest) async throws
    -> TwoFactorSignInEmailResponse
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.sessionStore.withSessionRefresh {
      return try await client.httpClient.request(
        route: BetterAuthRoute.signInEmail,
        body: body,
        responseType: TwoFactorSignInEmailResponse.self
      )
    }
  }
}

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
      -> TwoFactorEnableResponse
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
      -> TwoFactorDisableResponse
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
      -> TwoFactorGenerateBackupCodesResponse
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
      -> TwoFactorGetTotpURIResponse
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
      -> TwoFactorSendOTPResponse
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
      -> TwoFactorVerifyBackupCodeResponse
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
      -> TwoFactorVerifyOTPResponse
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
      -> TwoFactorVerifyTOTPResponse
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
