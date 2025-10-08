//
//  ContentView.swift
//  BetterAuthSwiftExample
//
//  Created by Guilherme D'Alessandro on 23/09/25.
//

import AuthenticationServices
import BetterAuth
import BetterAuthPhoneNumber
import BetterAuthTwoFactor
import BetterAuthUsername
import SwiftUI

extension String {
  static func randomString(length: Int) -> String {
    let characters =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in characters.randomElement()! })
      .lowercased()
  }
}

struct ContentView: View {
  @StateObject private var client = BetterAuthClient(
    baseURL: URL(string: "http://localhost:3001")!,
    plugins: [TwoFactorPlugin(), UsernamePlugin(), PhoneNumberPlugin()]
  )
  @State var email = "\(UUID().uuidString)@test.com"
  @State var username = "\(String.randomString(length: 5))"
  @State var password: String = "12345678"
  @State var otp: String = ""

  var body: some View {
    VStack {
      if let user = client.user {
        Spacer()
        Text("Hello, \(user.name)")
        Text("2fa enabled? \(user.twoFactorEnabled?.description ?? "nil")")
        Text("phone number: \(user.phoneNumber?.description ?? "none")")
        Button {
          print(user)
        } label: {
          Text("Print user")
        }

      }

      Spacer()

      if client.session != nil {
        VStack {
          HStack(spacing: 10) {
            Button {
              Task {
                do {
                  let res = try await client.getSession()
                  print(res.data ?? "nil")
                } catch {
                  print(error)
                }
              }
            } label: {
              Text("Get session")
            }.buttonStyle(.glass)

            Button {
              Task {
                do {
                  if client.user?.twoFactorEnabled == true {
                    let res = try await client.twoFactor.disable(
                      with: .init(password: password)
                    )
                    print(res)
                  } else {
                    let res = try await client.twoFactor.enable(
                      with: .init(password: password)
                    )
                    print(res)
                  }
                } catch {
                  print(error)
                }
              }
            } label: {
              Text("2FA")
            }

            Button {
              Task {
                try await client.signOut()
              }
            } label: {
              Text("Sign out")
            }.buttonStyle(.glass).tint(.red)
          }

          Button {
            Task {
              do {
                let _ = try await client.phoneNumber.sendOtp(
                  with: .init(phoneNumber: "+1234567890")
                )
              } catch {
                print(error)
              }
            }
          } label: {
            Text("Send phone number OTP")
          }.buttonStyle(.glass)

          TextField(text: $otp) {
            Text("OTP")
          }

          Button {
            Task {
              do {
                let _ = try await client.phoneNumber.verify(
                  with: .init(
                    phoneNumber: "+1234567890",
                    code: otp,
                    disableSession: false,
                    updatePhoneNumber: true
                  )
                )
              } catch {
                print(error)
              }
            }
          } label: {
            Text("Confirm OTP")
          }.buttonStyle(.glass)
        }
      } else {
        VStack(spacing: 10) {
          HStack(spacing: 10) {
            Button {
              Task {
                do {
                  let res = try await client.signIn.email(
                    with: .init(email: email, password: password)
                  )

                  switch res.twoFactorResponse {
                  case .twoFactorRedirect(let twoFA):
                    print(twoFA)
                  case .success(let res):
                    print(res)
                  }

                  if let res = res.data {
                    print(res.token)
                  }
                  if let twoFactorRedirect = res.context.twoFactorRedirect {
                    print(twoFactorRedirect)
                  }
                } catch {
                  print(error)
                }
              }
            } label: {
              Text("Sign in")
            }.buttonStyle(.glass)
            Button {
              Task {
                let res = try await client.signIn.username(
                  with: .init(username: username, password: password)
                )
              }
            } label: {
              Text("Sign in username")
            }.buttonStyle(.glass)
            Button {
              Task {
                try await client.signUp.email(
                  with: .init(email: email, password: password, name: "Gui")
                )
              }
            } label: {
              Text("Sign up email")
            }.buttonStyle(.glass)
            Button {
              Task {
                try await client.signUp.email(
                  with: .init(
                    email: email,
                    password: password,
                    name: "Gui",
                    username: username
                  )
                )
              }
            } label: {
              Text("Sign up username")
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

                  _ = try await client.signIn.social(
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
