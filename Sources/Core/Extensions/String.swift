import Foundation

extension String {
  package func withSchemeSuffix() -> String {
    if !self.hasSuffix("://") {
      return "\(self)://"
    }

    return self
  }
}
