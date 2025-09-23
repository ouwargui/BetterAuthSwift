import Foundation
import Testing
@testable import BetterAuth

@Test func example() async throws {
  let client = BetterAuthClient(baseURL: URL(string: "http://localhost:3001/api/auth")!)
  
  #expect(client.session == nil, "Expected session to be nil, received \(client.session)")

  let email = "gui+\(UUID().uuidString)@test.com"

  do {
    let signupResponse = try await client.signUp.email(with: .init(email: email, password: "12345678", name: "Gui"))

    #expect(
      signupResponse.user.email == client.session?.user.email,
      "Expected emails to match, received \(signupResponse.user.email) and \(client.session?.user.email)"
    )
  } catch {
    #expect(Bool(false), "Expected signup to succeed, received \(error)")
  }
}
