import Foundation

public struct BetterAuthSwiftError: Codable, Sendable, LocalizedError {
  public let message: String?

  public var errorDescription: String? {
    return "BetterAuthSwiftError: \(message ?? "Unknown error")"
  }
}

public struct BetterAuthError: Codable, Sendable, LocalizedError {
  public let code: String?
  public let message: String?
  public let status: Int?
  public let statusText: String?

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
