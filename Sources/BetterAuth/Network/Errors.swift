import Foundation

public struct BetterAuthSwiftError: Codable, Sendable, LocalizedError {
  public let message: String?

  public var errorDescription: String? {
    return "BetterAuthSwiftError: \(message ?? "Unknown error")"
  }
  
  public init(message: String?) {
    self.message = message
  }
}

public struct BetterAuthError: Codable, Sendable, LocalizedError {
  public let code: String?
  public let message: String?
  public let status: Int?
  public let statusText: String?
  
  public init(code: String?, message: String?, status: Int?, statusText: String?) {
    self.code = code
    self.message = message
    self.status = status
    self.statusText = statusText
  }

  public var errorDescription: String? {
    if let message = message {
      return message
    }

    if let code = code {
      return code
    }

    return statusText
  }
}
