//
//  ContentView.swift
//  BetterAuthSwiftExample
//
//  Created by Guilherme D'Alessandro on 23/09/25.
//

import AuthenticationServices
import BetterAuth
import BetterAuthEmailOTP
import BetterAuthMagicLink
import BetterAuthPasskey
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

enum Screen: String, Hashable, Identifiable, CaseIterable {
  case core
  case phoneNumber
  case twoFactor
  case username
  case magicLink
  case emailOTP
  case passkeyView

  var id: String { rawValue }

  var title: String {
    switch self {
    case .core:
      "Core"
    case .phoneNumber:
      "Phone Number"
    case .twoFactor:
      "Two Factor"
    case .username:
      "Username"
    case .magicLink:
      "Magic Link"
    case .emailOTP:
      "Email OTP"
    case .passkeyView:
      "Passkey"
    }
  }
}

struct ContentView: View {
  @StateObject private var client = BetterAuthClient(
    baseURL: URL(string: "https://c10c12aae565.ngrok-free.app")!,
    plugins: [
      TwoFactorPlugin(), UsernamePlugin(), PhoneNumberPlugin(),
      MagicLinkPlugin(), EmailOTPPlugin(), PasskeyPlugin(),
    ],
  )
  @State private var path: [Screen] = []
  @Binding var deepLink: DeepLink?

  var body: some View {
    NavigationStack(path: $path) {
      List {
        ForEach(Screen.allCases) { screen in
          Button(screen.title) {
            path.append(screen)
          }
        }
      }
      .navigationTitle("Better Auth")
      .navigationDestination(for: Screen.self) { screen in
        destinationView(for: screen)
          .navigationTitle(screen.title)
          #if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
              ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                  Task {
                    _ = try await client.signOut()
                  }
                }
              }
            }
          #endif
      }
    }
    .environmentObject(client)
    .task {
      await self.client.session.refreshSession()
    }
    .onChange(of: self.client.session.error) { _, err in
      guard let err = err else { return }
      print(err)
    }
    .onChange(of: deepLink) { _, link in
      guard let link, let token = link.token else { return }
      Task {
        do {
          _ = try await client.magicLink.verify(with: .init(token: token))
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }

  @ViewBuilder
  func destinationView(for screen: Screen) -> some View {
    switch screen {
    case .core:
      CoreView()
    case .phoneNumber:
      PhoneNumberView()
    case .twoFactor:
      TwoFactorView()
    case .username:
      UsernameView()
    case .magicLink:
      MagicLinkView()
    case .emailOTP:
      EmailOTPView()
    case .passkeyView:
      PasskeyView()
    }
  }
}
