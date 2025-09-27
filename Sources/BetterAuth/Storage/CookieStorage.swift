import Foundation

public protocol CookieStorageProtocol: HTTPCookieStorage {
  func getBetterAuthCookie() -> HTTPCookie?
  func setCookie(_ cookie: String, for url: URL) throws
}

public class CookieStorage: HTTPCookieStorage, CookieStorageProtocol, @unchecked Sendable {
  private let keychain: StorageProtocol
  private let cookieKey = "better-auth.persistent-cookies"
  private var cookieStore: [HTTPCookie] = []

  public init(storage: StorageProtocol = KeychainStorage()) {
    self.keychain = storage
    super.init()
    self.loadCookiesFromKeychain()
  }

  public func getBetterAuthCookie() -> HTTPCookie? {
    return cookieStore.first { cookie in
      cookie.name == cookieKey && !isExpired(cookie)
    }
  }

  public func setCookie(_ cookie: String, for url: URL) throws {
    let host = try url.getHost()
    let httpCookie = HTTPCookie.cookies(
      withResponseHeaderFields: ["Set-Cookie": cookie],
      for: host
    )

    guard let cookie = httpCookie.first else {
      throw BetterAuthSwiftError(
        message: "Failed to get session cookie from callbackURL"
      )
    }

    self.setCookie(cookie)
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
    return cookieStore.filter { !isExpired($0) }
  }

  public override func cookies(for URL: URL) -> [HTTPCookie]? {
    return cookieStore.filter { cookie in
      return !isExpired(cookie) && shouldSendCookie(cookie, for: URL)
    }
  }

  public override func setCookie(_ cookie: HTTPCookie) {
    cookieStore.removeAll {
      $0.name == cookie.name && $0.domain == cookie.domain
        && $0.path == cookie.path
    }

    cookieStore.append(cookie)

    saveCookiesToKeychain()
  }

  public override func setCookies(
    _ cookies: [HTTPCookie],
    for URL: URL?,
    mainDocumentURL: URL?
  ) {
    cookies.forEach { cookie in
      cookieStore.removeAll {
        $0.name == cookie.name && $0.domain == cookie.domain
          && $0.path == cookie.path
      }

      cookieStore.append(cookie)
    }

    saveCookiesToKeychain()
  }

  public override func deleteCookie(_ cookie: HTTPCookie) {
    cookieStore.removeAll {
      $0.name == cookie.name && $0.domain == cookie.domain
    }
    saveCookiesToKeychain()
  }

  public override func removeCookies(since date: Date) {
    cookieStore.removeAll()
    saveCookiesToKeychain()
  }

  private func saveCookiesToKeychain() {
    do {
      let cookieData = try JSONEncoder().encode(
        cookieStore.map(CookieData.init)
      )
      let jsonString = String(data: cookieData, encoding: .utf8) ?? ""
      let _ = try keychain.save(key: cookieKey, value: jsonString)
      print("CookieStorage: Saved \(cookieStore.count) cookies to keychain")
    } catch {
      print("CookieStorage: Failed to save cookies")
    }
  }

  private func loadCookiesFromKeychain() {
    guard let jsonString = keychain.get(key: cookieKey),
      let data = jsonString.data(using: .utf8)
    else {
      return
    }

    do {
      let cookieDataArray = try JSONDecoder().decode(
        [CookieData].self,
        from: data
      )

      cookieStore = cookieDataArray.compactMap { $0.toHTTPCookie() }

      let initialCount = cookieStore.count
      cookieStore.removeAll { isExpired($0) }

      if initialCount != cookieStore.count {
        saveCookiesToKeychain()
      }
    } catch {
      print("Failed to load cookies")
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
