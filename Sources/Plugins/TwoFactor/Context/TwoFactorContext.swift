import BetterAuth

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
