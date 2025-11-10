//
//  genericOAuthView.swift
//  BetterAuthSwift
//
//  Created by Robin Augereau on 07/11/2025.
//

import SwiftUI
import BetterAuth
import BetterAuthGenericOAuth

struct GenericOAuthView: View {
    @EnvironmentObject var client: BetterAuthClient
    
    @State private var providerId = ""
    @State private var isSigningIn = false
    @State private var errorMessage: String?
    
    #if !os(watchOS)
    var body: some View {
        VStack(spacing: 24) {
            if let user = client.session.data?.user {
                // MARK: - Logged-in User
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
                        Task { try? await client.signOut() }
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
                // MARK: - OAuth2 Form
                VStack(spacing: 16) {
                    Image(systemName: "person.badge.key.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(.tint)
                        .padding(.bottom, 6)
                    
                    Text("Sign in with OAuth2")
                        .font(.headline)
                    
                    TextField("Provider ID", text: $providerId)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(12)
                        .background(Color(.secondarySystemFill))
                        .cornerRadius(8)
                    
                    Button {
                        signInWithOAuth2()
                    } label: {
                        Label("Sign In", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.accentColor.gradient))
                    }
                    .disabled(providerId.isEmpty || isSigningIn)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .frame(maxWidth: 380)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.tertiarySystemFill))
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                .overlay(alignment: .center) {
                    if isSigningIn {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.3)
                    }
                }
            }
        }
        .padding()
        .animation(.spring(duration: 0.35), value: client.session.data?.user.id)
    }
    
    // MARK: - Logic
    private func signInWithOAuth2() {
        Task {
            isSigningIn = true
            errorMessage = nil
            do {
                _ = try await client.signIn.oauth2(
                    with: .init(
                        providerId: providerId,
                        callbackURL: "betterauthswiftexample://"
                    )
                )
            } catch {
                errorMessage = "Failed to sign in: \(error.localizedDescription)"
            }
            isSigningIn = false
        }
    }
    #else
    var body: some View {
        Text("OAuth2 is not supported on watchOS")
            .foregroundColor(.secondary)
            .padding()
    }
    #endif
}