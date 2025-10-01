#  Sign in with 2FA

Learn how to sign in an user that has 2FA enabled.

When a user with 2FA enabled tries to sign in via email, the response object
will contain `twoFactorRedirect` set to `true`. This indicates that the user needs
to verify their 2FA code. You can handle this by providing a type annotation to
the signIn response:

```swift
// Explicitly annotate the type
let res: TwoFactorSignInEmailResponse = client.signIn.email(with: body)

switch res {
case .requires2FA(let requires2FAResponse):
  print(requires2FAResponse) // Bool
case .user(let user):
  print(user) // User
}
```

The Swift client don't support the global handler yet. Let us know if this is something that you'd want.
