import Foundation

@MainActor
public protocol PluginFactory: Sendable {
  static var id: String { get }
  static func create(client: BetterAuthClient) -> Pluggable
}

@MainActor
public class PluginRegistry {
  private var plugins: [String: Pluggable] = [:]
  private let factories: [PluginFactory]

  public init(factories: [PluginFactory]) {
    self.factories = factories
  }

  public func register(client: BetterAuthClient) {
    for factory in factories {
      let plugin = type(of: factory).create(client: client)
      let id = type(of: factory).id
      guard plugins[id] == nil else {
        preconditionFailure("Plugin \(id) already registered")
      }
      plugins[id] = plugin
    }
  }

  public func get<T: Pluggable>(id: String) -> T {
    guard let plugin = plugins[id] as? T else {
      preconditionFailure("Plugin \(id) not registered")
    }
    return plugin
  }

  public func all() async -> [Pluggable] { Array(plugins.values) }
}
