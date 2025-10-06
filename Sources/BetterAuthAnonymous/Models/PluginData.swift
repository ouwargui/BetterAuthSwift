import Foundation

internal enum AnonymousPluginData {
  case isAnonymous

  var pluginFieldName: String {
    switch self {
    case .isAnonymous:
      "isAnonymous"
    }
  }
}
