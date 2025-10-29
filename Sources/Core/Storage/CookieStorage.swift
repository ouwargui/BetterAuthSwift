import Foundation
import OSLog

public protocol CookieStorageProtocol: HTTPCookieStorage {
  func getBetterAuthCookie() -> HTTPCookie?
  func setCookie(_ cookie: String, for url: URL) throws
}

public final class CookieStorage: HTTPCookieStorage, CookieStorageProtocol,
  Lockable,
  @unchecked Sendable
{
  private let keychain: StorageProtocol
  private let keychainKey = "better-auth.persistent-cookies"
  private let betterAuthSessionCookieKey = "better-auth.session_token"
  package let lock = NSLock()
  private var _cookieStore: [HTTPCookie] = []
  private let logger = Logger(
    subsystem: "com.betterauth",
    category: "CookieStorage"
  )

  public init(storage: StorageProtocol) {
    self.keychain = storage
    super.init()
    self.loadCookiesFromKeychain()
  }

  internal override init() {
    self.keychain = KeychainStorage()
    super.init()
    self.loadCookiesFromKeychain()
  }

  public func getBetterAuthCookie() -> HTTPCookie? {
    return withLock {
      _cookieStore.first { cookie in
        cookie.name == betterAuthSessionCookieKey && !isExpired(cookie)
      }
    }
  }

  public func setCookie(_ cookie: String, for url: URL) throws {
    let host = try url.getHost()
    self.setCookies(
      HTTPCookie.cookies(fromCombinedHeader: cookie, for: host),
      for: host,
      mainDocumentURL: nil
    )
  }

  public override func storeCookies(
    _ cookies: [HTTPCookie],
    for task: URLSessionTask
  ) {
    guard let url = task.currentRequest?.url else {
      return
    }

    self.setCookies(cookies, for: url, mainDocumentURL: nil)
  }

  public override func getCookiesFor(
    _ task: URLSessionTask,
    completionHandler: @escaping ([HTTPCookie]?) -> Void
  ) {
    guard let url = task.currentRequest?.url else {
      completionHandler(nil)
      return
    }

    let cookies = self.cookies(for: url)
    completionHandler(cookies)
  }

  public override var cookies: [HTTPCookie]? {
    return withLock {
      _cookieStore.filter { !isExpired($0) }
    }
  }

  public override func cookies(for URL: URL) -> [HTTPCookie]? {
    return withLock {
      _cookieStore.filter { cookie in
        return !isExpired(cookie) && shouldSendCookie(cookie, for: URL)
      }
    }
  }

  public override func setCookie(_ cookie: HTTPCookie) {
    withLock {
      _cookieStore.removeAll {
        $0.name == cookie.name && $0.domain == cookie.domain
          && $0.path == cookie.path
      }
      _cookieStore.append(cookie)
    }

    saveCookiesToKeychain()
  }

  public override func setCookies(
    _ cookies: [HTTPCookie],
    for URL: URL?,
    mainDocumentURL: URL?
  ) {
    withLock {
      for cookie in cookies {
        _cookieStore.removeAll {
          $0.name == cookie.name && $0.domain == cookie.domain
            && $0.path == cookie.path
        }
        _cookieStore.append(cookie)
      }
    }

    saveCookiesToKeychain()
  }

  public override func deleteCookie(_ cookie: HTTPCookie) {
    withLock {
      _cookieStore.removeAll {
        $0.name == cookie.name && $0.domain == cookie.domain
      }
    }

    saveCookiesToKeychain()
  }

  public override func removeCookies(since date: Date) {
    withLock {
      _cookieStore.removeAll()
    }

    saveCookiesToKeychain()
  }

  private func saveCookiesToKeychain() {
    let currentCookies = withLock { _cookieStore }

    do {
      let cookieData = try JSONEncoder().encode(
        currentCookies.map(CookieData.init)
      )
      let jsonString = String(data: cookieData, encoding: .utf8) ?? ""
      let _ = try keychain.save(key: keychainKey, value: jsonString)
      logger.debug("Saved \(currentCookies.count) cookies to keychain")
    } catch {
      logger.error("Failed to save cookies")
    }
  }

  private func loadCookiesFromKeychain() {
    guard let jsonString = keychain.get(key: keychainKey),
      let data = jsonString.data(using: .utf8)
    else {
      return
    }

    do {
      let cookieDataArray = try JSONDecoder().decode(
        [CookieData].self,
        from: data
      )

      let loadedCookies = cookieDataArray.compactMap { $0.toHTTPCookie() }
      let validCookies = loadedCookies.filter { !isExpired($0) }

      withLock {
        _cookieStore = validCookies
      }

      if loadedCookies.count != validCookies.count {
        saveCookiesToKeychain()
      }
    } catch {
      logger.error("Failed to load cookies")
    }
  }

  private func isExpired(_ cookie: HTTPCookie) -> Bool {
    guard let expiresDate = cookie.expiresDate else {
      return false
    }

    return expiresDate < Date()
  }

  private func shouldSendCookie(_ cookie: HTTPCookie, for url: URL) -> Bool {
    do {
      let host = try url.getHost()

      if host.host != cookie.domain {
        return false
      }

      if !url.path.hasPrefix(cookie.path) {
        return false
      }

      if cookie.isSecure && url.scheme != "https" {
        return false
      }

      return true
    } catch {
      return false
    }
  }
}

private struct CookieData: Codable {
  let name: String
  let value: String
  let domain: String
  let path: String
  let expiresDate: Date?
  let isSecure: Bool
  let isHTTPOnly: Bool
  let sameSitePolicy: String?

  init(from cookie: HTTPCookie) {
    self.name = cookie.name
    self.value = cookie.value
    self.domain = cookie.domain
    self.path = cookie.path
    self.expiresDate = cookie.expiresDate
    self.isSecure = cookie.isSecure
    self.isHTTPOnly = cookie.isHTTPOnly

    if #available(iOS 13.0, macOS 10.15, *) {
      switch cookie.sameSitePolicy {
      case .sameSiteLax:
        self.sameSitePolicy = "Lax"
      case .sameSiteStrict:
        self.sameSitePolicy = "Strict"
      case .none:
        self.sameSitePolicy = "None"
      default:
        self.sameSitePolicy = nil
      }
    } else {
      self.sameSitePolicy = nil
    }
  }

  func toHTTPCookie() -> HTTPCookie? {
    var properties: [HTTPCookiePropertyKey: Any] = [
      .name: name,
      .value: value,
      .domain: domain,
      .path: path,
    ]

    if let expiresDate = expiresDate {
      properties[.expires] = expiresDate
    }

    if isSecure {
      properties[.secure] = true
    }

    if isHTTPOnly {
      properties[.init("HttpOnly")] = true
    }

    if #available(iOS 13.0, macOS 10.15, *), let sameSite = sameSitePolicy {
      properties[.sameSitePolicy] = sameSite
    }

    return HTTPCookie(properties: properties)
  }
}
