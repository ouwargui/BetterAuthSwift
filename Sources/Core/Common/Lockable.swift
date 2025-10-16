import Foundation

package protocol Lockable {
  var lock: NSLock { get }
}

extension Lockable {
  func withLock<T>(_ action: () -> T) -> T {
    lock.lock()
    defer { lock.unlock() }
    return action()
  }

  func withLock(_ action: () -> Void) {
    lock.lock()
    defer { lock.unlock() }
    action()
  }
}
