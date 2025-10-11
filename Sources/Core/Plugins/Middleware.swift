import Foundation

public struct MiddlewareActions: Hashable, Sendable, ExpressibleByStringLiteral
{
  public let name: String

  public init(_ name: String) {
    self.name = name
  }

  public init(stringLiteral value: StringLiteralType) {
    self.name = value
  }
}

public struct HTTPRequestContext: Sendable {
  public var path: String
  public var method: String
  public var headers: [String: String]
  public var body: AnyEncodable?
  public var query: AnyEncodable?

  public init(
    path: String,
    method: String,
    headers: [String: String] = [:],
    body: AnyEncodable? = nil,
    query: AnyEncodable? = nil,
  ) {
    self.path = path
    self.method = method
    self.headers = headers
    self.body = body
    self.query = query
  }

  public func buildUrlRequest(baseURL: URL, encoder: JSONEncoder) throws
    -> URLRequest
  {
    var url: URL {
      if #available(macOS 13.0, iOS 16.0, watchOS 9.0, *) {
        return baseURL.appending(path: self.path)
      } else {
        return baseURL.appendingPathComponent(self.path)
      }
    }

    var request = URLRequest(url: url)
    request.httpMethod = self.method
    request.httpShouldHandleCookies = true
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    for (k, v) in self.headers {
      request.setValue(v, forHTTPHeaderField: k)
    }

    if let body = self.body {
      request.httpBody = try encoder.encode(body)
    }
    if let query = self.query {
      request.addQueryItems(query.toQueryItems())
    }

    return request
  }
}

public struct HTTPResponseContext: Sendable {
  public var urlResponse: HTTPURLResponse
  public var bodyData: Data
  public var meta: [String: AnyCodable]

  public init(
    urlResponse: HTTPURLResponse,
    bodyData: Data,
    meta: [String: AnyCodable] = [:]
  ) {
    self.urlResponse = urlResponse
    self.bodyData = bodyData
    self.meta = meta
  }
}

public protocol AuthPlugin: Sendable {
  var id: String { get }
  func willSend(_ action: MiddlewareActions, request: inout HTTPRequestContext)
    async throws
  func didReceive(
    _ action: MiddlewareActions,
    response: inout HTTPResponseContext
  )
    async throws
}

extension AuthPlugin {
  public func willSend(
    _ action: MiddlewareActions,
    request: inout HTTPRequestContext
  )
    async throws
  {}
  public func didReceive(
    _ action: MiddlewareActions,
    response: inout HTTPResponseContext
  ) async throws {}
}
