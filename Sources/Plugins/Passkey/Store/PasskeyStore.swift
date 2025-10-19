#if !os(watchOS)
  import Foundation
  import BetterAuth
  import OSLog
  import Combine

  @available(iOS 15.0, macOS 12.0, *)
  @MainActor
  public class PasskeyStore: ObservableObject {
    @Published public private(set) var data: PasskeyListUserPasskeysResponse?
    @Published public private(set) var isPending: Bool = false
    @Published public private(set) var error: BetterAuthError?

    private let httpClient: HTTPClientProtocol
    private let logger = Logger(
      subsystem: "com.betterauth",
      category: "passkey"
    )

    private let LISTENED_SIGNALS: [Signal] = [
      .signout,
      .passkeyDeletePasskey,
      .passkeyUpdatePasskey,
      .passkeyVerifyRegistration,
    ]

    private var cancellables = Set<AnyCancellable>()

    init(httpClient: HTTPClientProtocol) {
      self.httpClient = httpClient

      SignalBus.shared.listen(to: LISTENED_SIGNALS, storeIn: &cancellables) {
        [weak self] _ in
        await self?.refreshPasskeys()
      }
    }

    package func update(_ passkeys: PasskeyListUserPasskeysResponse?) {
      self.data = passkeys
      guard let passkeys = passkeys else {
        logger.debug("Passkeys updated: nil")
        return
      }
      logger.debug("Passkeys updated: \(passkeys)")
    }

    private func setLoading(_ loading: Bool) {
      self.isPending = loading
    }

    public func refreshPasskeys() async {
      setLoading(true)
      defer { setLoading(false) }

      do {
        let passkeys:
          APIResource<PasskeyListUserPasskeysResponse, EmptyContext> =
            try await httpClient.perform(
              route: BetterAuthPasskeyRoute.passkeyListUserPasskeys,
              responseType: PasskeyListUserPasskeysResponse.self
            )

        update(passkeys.data)
      } catch let error as BetterAuthApiError {
        update(nil)
        self.error = .apiError(error)
      } catch let error as BetterAuthSwiftError {
        update(nil)
        self.error = .libError(error)
      } catch {
        update(nil)
        self.error = .unknownError(error)
      }
    }
  }
#endif
