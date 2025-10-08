import BetterAuth
import Foundation

extension BetterAuthContext where C == SignInContext {
  public var twoFactorRedirect: TwoFactorRedirect? {
    self.meta[TwoFactorPluginData.twoFactorRedirect.pluginFieldName]?.value
      as? TwoFactorRedirect
  }
}

extension APIResource where C == SignInContext, T: OptionalType {
  public enum TwoFactorSignInResponse<Success> {
    case success(Success)
    case twoFactorRedirect(TwoFactorRedirect)
  }
  
  public var twoFactorResponse: TwoFactorSignInResponse<T.Wrapped> {
    if let twoFactorRedirect = self.context.twoFactorRedirect {
      return .twoFactorRedirect(twoFactorRedirect)
    }
    
    return .success(self.data.optional!)
  }
}

public struct TwoFactorPlugin: AuthPlugin {
  public let id: String = "twoFactor"

  public init() {}

  public func didReceive(
    _ action: MiddlewareActions,
    response: inout HTTPResponseContext
  ) async throws {
    let actionsToHandle: [MiddlewareActions] = [.signInEmail, .signInUsername]
    guard actionsToHandle.contains(where: { $0 == action }) else { return }

    guard
      let twoFactorBody = try? JSONDecoder().decode(
        TwoFactorSignInResponse.self,
        from: response.bodyData
      )
    else { return }

    response.meta[TwoFactorPluginData.twoFactorRedirect.pluginFieldName] =
      AnyCodable(twoFactorBody.twoFactorRedirect)
  }
}
