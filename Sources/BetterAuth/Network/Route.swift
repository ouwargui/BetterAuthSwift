import Foundation

enum BetterAuthRoute {
  case signUpEmail
  case signInEmail
  case signInSocial
  case signOut
  case getSession
  
  var path: String {
    switch self {
    case .getSession:
      return "/get-session"
    case .signInSocial:
      return "/sign-in/social"
    case .signInEmail:
      return "/sign-in/email"
    case .signUpEmail:
      return "/sign-up/email"
    case .signOut:
      return "/sign-out"
    }
  }
  
  var triggerSessionRefresh: Bool {
    switch self {
    case .signInEmail, .signUpEmail, .signOut, .signInSocial:
      return true
    default:
      return false
    }
  }
  
  var method: String {
    switch self {
    case .signInEmail, .signUpEmail, .signOut, .signInSocial:
      return "POST"
    case .getSession:
      return "GET"
    }
  }
}
