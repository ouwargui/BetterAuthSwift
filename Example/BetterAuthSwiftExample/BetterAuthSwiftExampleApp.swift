//
//  BetterAuthSwiftExampleApp.swift
//  BetterAuthSwiftExample
//
//  Created by Guilherme D'Alessandro on 23/09/25.
//

import SwiftUI

struct DeepLink: Equatable {
  var path: String
  var token: String?
  var id: String?

  init?(url: URL) {
    print(url.absoluteString)
    guard url.scheme == "betterauthswiftexample" else { return nil }
    self.path = url.host ?? ""
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
       let queryItems = components.queryItems {
      for item in queryItems {
        if item.name == "token" {
          self.token = item.value
        }
      }
    }
    if let id = url.pathComponents.dropFirst().first {
      self.id = id
    }
  }
}

@main
struct BetterAuthSwiftExampleApp: App {
  @State private var deepLink: DeepLink?

  var body: some Scene {
    WindowGroup {
      ContentView(deepLink: $deepLink)
        .onOpenURL { url in
          self.deepLink = DeepLink(url: url)
        }
    }
  }
}
