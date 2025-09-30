import BetterAuth
import Foundation

extension BetterAuthClient.SignIn {
  public func email(with body: SignInEmailRequest) async throws
    -> TwoFactorSignInEmailResponse
  {
    guard let client = self.client else {
      throw BetterAuthSwiftError(message: "Client deallocated")
    }

    return try await client.httpClient.request(
      route: BetterAuthRoute.signInEmail,
      body: body,
      responseType: TwoFactorSignInEmailResponse.self
    )
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
