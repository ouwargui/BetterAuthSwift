import Foundation

@MainActor
final class PasskeyStore: ObservableObject {
  @Published private var _passkeys: [PasskeyVerifyRegistrationResponse]?
  
  var passkeys: [PasskeyVerifyRegistrationResponse] {
    if _passkeys == nil {
      _passkeys = []
    }
    return _passkeys!
  }
}
