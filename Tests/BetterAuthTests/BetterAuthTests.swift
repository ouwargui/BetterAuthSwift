import Foundation
import Testing

@testable import BetterAuth

@Test func urlReturnsCorrectBaseURL() async {
  var url = URL(string: "http://localhost:3001")!

  #expect(
    url.getBaseURL().absoluteString == "http://localhost:3001/api/auth",
    "Expected base URL to be http://localhost:3001/api/auth, received \(url.getBaseURL())"
  )

  url = URL(string: "http://localhost:3001/")!

  #expect(
    url.getBaseURL().absoluteString == "http://localhost:3001/api/auth",
    "Expected base URL to be http://localhost:3001/api/auth, received \(url.getBaseURL())"
  )

  url = URL(string: "http://localhost:3001/custom/path")!

  #expect(
    url.getBaseURL().absoluteString == "http://localhost:3001/custom/path",
    "Expected base URL to be http://localhost:3001/custom/path, received \(url.getBaseURL())"
  )
}

@Test func urlReturnsCorrectHost() async {
  var url = URL(string: "http://localhost:3001")!

  #expect(
    url.hostname == "localhost",
    "Expected hostname to be localhost, received \(url.hostname)"
  )

  url = URL(string: "https://dbw2dada.adsansdsa.com")!

  #expect(
    url.hostname == "dbw2dada.adsansdsa.com",
    "Expected hostname to be dbw2dada.adsansdsa.com, received \(url.hostname)"
  )
}

@Test func stringwithSchemeSuffixReturnsCorrectScheme() async {
  var scheme = "scheme"
  #expect(
    scheme.withSchemeSuffix() == "scheme://",
    "Expected scheme to be scheme://, received \(scheme.withSchemeSuffix())"
  )
  
  scheme = "scheme://"
  #expect(
    scheme.withSchemeSuffix() == "scheme://",
    "Expected scheme to be scheme://, received \(scheme.withSchemeSuffix())"
  )
}

@Test func betterAuthClientGetCookieReturnsTheBetterAuthCookie() async throws {
  let baseURL = URL(string: "http://localhost:3001")!

  let cookieStorage = CookieStorage(storage: InMemoryStorage())

  let cookieName = "better-auth.persistent-cookies"
  let cookieValue = "abc123"
  let cookieString = "\(cookieName)=\(cookieValue); Path=/"
  try cookieStorage.setCookie(cookieString, for: baseURL)

  let client = await MainActor.run {
    BetterAuthClient(
      baseURL: baseURL,
      scheme: "betterauthswifttest://",
      httpClient: MockHTTPClient(
        baseURL: baseURL,
        pluginRegistry: PluginRegistry(factories: []),
        cookieStorage: cookieStorage
      )
    )
  }

  let returnedCookie = await MainActor.run { client.getCookie() }

  #expect(returnedCookie != nil, "Expected a cookie to be returned")
  #expect(
    returnedCookie?.name == cookieName,
    "Expected cookie with correct name"
  )
  #expect(
    returnedCookie?.value == cookieValue,
    "Expected cookie with correct value"
  )
}
