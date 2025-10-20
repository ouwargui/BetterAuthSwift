import AuthenticationServices
import BetterAuth
import SwiftUI

struct CoreView: View {
  @EnvironmentObject var client: BetterAuthClient

  var body: some View {
    VStack(spacing: 24) {
      if let user = client.session.data?.user {
        HStack(alignment: .center, spacing: 16) {
          AsyncImage(url: URL(string: user.image ?? "")) { image in
            image.resizable()
          } placeholder: {
            Circle()
              .fill(Color.gray.opacity(0.3))
              .overlay(
                Image(systemName: "person.fill")
                  .foregroundColor(.gray)
              )
          }
          .frame(width: 60, height: 60)
          .clipShape(Circle())
          .shadow(radius: 2)

          VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
              .font(.headline)
              .foregroundColor(.primary)

            Text(user.email)
              .font(.subheadline)
              .foregroundColor(.secondary)
          }

          Spacer()

          Button {
            Task {
              try? await client.signOut()
            }
          } label: {
            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
              .font(.subheadline.bold())
              .foregroundColor(.white)
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(Capsule().fill(Color.red.gradient))
          }
          .buttonStyle(.plain)
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemFill))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )

        Text("Welcome back, \(user.name)!")
          .font(.title3)
          .fontWeight(.semibold)
      } else {
        VStack(spacing: 12) {
          Image(systemName: "person.crop.circle.badge.plus")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .foregroundStyle(.tint)
            .padding(.bottom, 4)

          Text("You’re not signed in yet")
            .font(.headline)

          Button("Sign in with Google") {
            Task {
              do {
                _ = try await client.signIn.social(
                  with: .init(provider: "google", callbackURL: "betterauthswiftexample://")
                )
              } catch {
                print(error)
              }
            }
          }

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
        .padding()
      }
    }
    .padding()
    .animation(.spring(duration: 0.35), value: client.session.data?.user.id)
  }
}
