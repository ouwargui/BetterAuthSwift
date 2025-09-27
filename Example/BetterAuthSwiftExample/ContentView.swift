//
//  ContentView.swift
//  BetterAuthSwiftExample
//
//  Created by Guilherme D'Alessandro on 23/09/25.
//

import AuthenticationServices
import BetterAuth
import SwiftUI

struct ContentView: View {
  @StateObject private var client = BetterAuthClient(
    baseURL: URL(string: "http://localhost:3001")!
  )
  @State var email = "gui+\(UUID().uuidString)@test.com"
  @State var password: String = "12345678"

  var body: some View {
    VStack {
      if let user = client.user {
        Spacer()
        Text("Hello, \(user.name)")
      }

      Spacer()

      if client.session != nil {
        HStack(spacing: 10) {
          Button {
            Task {
              do {
                let sess = try await client.getSession()
                print(sess ?? "nil")
              } catch {
                print(error)
              }
            }
          } label: {
            Text("Get session")
          }.buttonStyle(.glass)

          Button {
            Task {
              try await client.signOut()
            }
          } label: {
            Text("Sign out")
          }.buttonStyle(.glass).tint(.red)
        }
      } else {
        VStack(spacing: 10) {
          HStack(spacing: 10) {
            Button {
              Task {
                try await client.signIn.email(
                  with: .init(email: email, password: password)
                )
              }
            } label: {
              Text("Sign in")
            }.buttonStyle(.glass)
            Button {
              Task {
                try await client.signUp.email(
                  with: .init(email: email, password: password, name: "Gui")
                )
              }
            } label: {
              Text("Sign up")
            }.buttonStyle(.glass)
          }

          VStack {
            Button {
              Task {
                let res = try await client.signIn.social(
                  with: .init(
                    provider: "google",
                    callbackURL: "betterauthswiftexample://"
                  )
                )
                print(res)
              }
            } label: {
              Text("Sign in with Google")
            }.buttonStyle(.glass)

            SignInWithAppleButton(.signIn) { request in
              request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
              Task {
                switch result {
                case .success(let authorization):
                  guard
                    let appleIdCredential = authorization.credential
                      as? ASAuthorizationAppleIDCredential,
                    let identityTokenData = appleIdCredential.identityToken,
                    let identityToken = String(
                      data: identityTokenData,
                      encoding: .utf8
                    )
                  else {
                    print("failed to get idtoken")
                    return
                  }

                  let res = try await client.signIn.social(
                    with: .init(
                      provider: "apple",
                      idToken: .init(token: identityToken)
                    )
                  )

                case .failure(let error):
                  print(
                    "sign in with apple failed \(error.localizedDescription)"
                  )
                }

              }
            }.frame(height: 50)
          }
        }
      }

      Spacer()

    }
    .padding()
  }
}
