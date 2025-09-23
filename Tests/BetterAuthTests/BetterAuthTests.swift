import Foundation
import Testing
@testable import BetterAuth

@Test func example() async throws {
  let client = BetterAuthClient(baseURL: URL(string: "http://localhost:3001/api/auth")!)

  let email = "gui+\(UUID().uuidString)@test.com"

  do {
    let signupResponse = try await client.signUp.email(with: .init(email: email, password: "12345678", name: "Gui"))

    let sessionResponse = try await client.getSession()

    #expect(
      signupResponse.user.email == sessionResponse.user.email,
      "Expected emails to match, received \(signupResponse.user.email) and \(sessionResponse.user.email)"
    )
  } catch {
    #expect(Bool(false), "Expected signup to succeed, received \(error)")
  }
}
