import Foundation
import Testing

@testable import BetterAuth

@Test func urlReturnsCorrectBaseURL() async throws {
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
