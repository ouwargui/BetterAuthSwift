import Foundation

public enum BetterAuthError: Equatable {
  case libError(BetterAuthSwiftError)
  case apiError(BetterAuthApiError)
  case unknownError(Error)

  public static func == (lhs: BetterAuthError, rhs: BetterAuthError) -> Bool {
    switch (lhs, rhs) {
    case (.libError(let a), .libError(let b)):
      return a == b
    case (.apiError(let a), .apiError(let b)):
      return a == b
    case (.unknownError(let a), .unknownError(let b)):
      return a.localizedDescription == b.localizedDescription
    default:
      return false
    }
  }
}

public struct BetterAuthSwiftError: Codable, Sendable, LocalizedError, Equatable
{
  public let message: String?

  public var errorDescription: String? {
    return "BetterAuthSwiftError: \(message ?? "Unknown error")"
  }

  public init(message: String?) {
    self.message = message
  }
}

package struct CoreError: Codable, Sendable {
  let code: String?
  let message: String?

  init(code: String?, message: String?) {
    self.code = code
    self.message = message
  }
}

public struct BetterAuthApiError: Codable, Sendable, LocalizedError, Equatable {
  public let code: String?
  public let message: String?
  public let status: Int?
  public let statusText: String?

  package init(coreError: CoreError, response: HTTPURLResponse) {
    self.code = coreError.code
    self.message = coreError.message
    self.status = response.statusCode
    self.statusText = HTTPURLResponse.localizedString(
      forStatusCode: response.statusCode
    )
  }

  public init(
    code: String?,
    message: String?,
    status: Int?,
    statusText: String?
  ) {
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
