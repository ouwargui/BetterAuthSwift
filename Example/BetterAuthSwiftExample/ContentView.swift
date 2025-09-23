//
//  ContentView.swift
//  BetterAuthSwiftExample
//
//  Created by Guilherme D'Alessandro on 23/09/25.
//

import SwiftUI
import BetterAuth

struct ContentView: View {
  @StateObject private var client = BetterAuthClient(baseURL: URL(string: "http://localhost:3001/api/auth")!)
  @State var email = "gui+\(UUID().uuidString)@test.com"
  @State var password: String = "12345678"
  
  var body: some View {
    VStack {
      if let user = client.session?.user {
        Spacer()
        Text("Hello, \(user.name)")
      }
      
      Spacer()
      
      TextField("Email", text: $email)
      TextField("Password", text: $password)
      
      Spacer()
      
      if client.session != nil {
        Button {
          Task {
            let res = try await client.signOut()

            print(res)
          }
        } label: {
          Text("Sign out")
        }
      } else {
        Button {
          Task {
            let res = try await client.signUp.email(with: .init(email: email, password: password, name: "Gui"))
            
            print(res.user.name)
          }
        } label: {
          Text("Sign up")
        }
      }
      
      Spacer()

    }
    .padding()
  }
}
