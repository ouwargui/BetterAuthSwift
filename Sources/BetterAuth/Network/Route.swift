import Foundation

enum BetterAuthRoute {
  case signUpEmail
  case signInEmail
  case signOut
  case getSession
  
  var path: String {
    switch self {
    case .getSession:
      return "/get-session"
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
    case .signInEmail, .signUpEmail, .signOut:
      return true
    default:
      return false
    }
  }
  
  var method: String {
    switch self {
    case .signInEmail, .signUpEmail, .signOut:
      return "POST"
    case .getSession:
      return "GET"
    }
  }
}
