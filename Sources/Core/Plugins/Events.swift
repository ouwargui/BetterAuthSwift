import Combine

package enum Signal {
  // MARK: Core
  case signout
  case updateUser
  case signIn
  case signUp
  case deleteUser
  case verifyEmail
  
  // MARK: Two Factor
  case twoFactor

  // MARK: Phone Number
  case phoneNumberVerify
  
  // MARK: Magic Link
  case magicLinkVerify

  // MARK: Passkey
  case passkeyVerifyRegistration
  case passkeyDeletePasskey
  case passkeyUpdatePasskey
  case passkeyVerifyAuthentication
  
  // MARK: Email OTP
  case emailOtpVerifyEmail
}

@MainActor
package final class SignalBus {
  public static let shared = SignalBus()
  private let subject = PassthroughSubject<Signal, Never>()

  private init() {}

  public var signals: AnyPublisher<Signal, Never> {
    subject.eraseToAnyPublisher()
  }

  public func send(_ signal: Signal) {
    subject.send(signal)
  }

  public func emittingSignal<T: Sendable>(
    _ signal: Signal,
    perform action: @escaping () async throws -> T
  ) async throws -> T {
    let res = try await action()

    self.send(signal)

    return res
  }

  @discardableResult
  public func listen(
    to listenedSignals: [Signal],
    storeIn cancellables: inout Set<AnyCancellable>,
    perform action: @escaping (Signal) async -> Void
  ) -> AnyCancellable {
    let cancellable =
      subject
      .filter { listenedSignals.contains($0) }
      .sink { signal in
        Task { await action(signal) }
      }

    cancellables.insert(cancellable)
    return cancellable
  }
}
