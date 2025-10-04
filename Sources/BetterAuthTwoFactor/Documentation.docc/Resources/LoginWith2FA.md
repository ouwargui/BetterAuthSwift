# Sign in with 2FA

Learn how to sign in an user that has 2FA enabled.

When a user with 2FA enabled tries to sign in via email or username (if enabled),
the response object will be overwritten with `twoFactorRedirect` set to `true`.
For this reason, some API responses will be `Optional` types.

You can handle this in one of the following ways:

```swift
let res = client.signIn.email(with: body)

// 1. Manually check the context
guard let twoFactorRedirect = res.context.twoFactorRedirect else {
  print("User does not need 2FA")
  return
}
print(twoFactorRedirect) // Bool

// 2. Use the twoFactorResponse helper property
switch res.twoFactorResponse {
case .twoFactorRedirect(let twoFA):
  print(twoFA) // Bool
case .success(let res):
  print(res) // SignInEmailResponse
}
```

The Swift client don't support the global handler yet. Let us know if this is something that you'd want.
