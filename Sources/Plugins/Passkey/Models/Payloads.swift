import BetterAuth
import Foundation

public struct PasskeySignInPasskeyRequest: Codable, Sendable {
  public let autoFill: Bool?

  public init(autoFill: Bool? = nil) {
    self.autoFill = autoFill
  }
}

public typealias PasskeySignInPasskeyResponse = PasskeyVerifyAuthenticationResponse

public enum PasskeyAuthenticatorAttachment: String, Codable, Sendable {
  case crossPlatform = "cross-platform"
  case platform
}

public struct PasskeyAddPasskeyRequest: Codable, Sendable {
  public let name: String?
  public let authenticatorAttachment: PasskeyAuthenticatorAttachment?

  public init(
    name: String? = nil,
    authenticatorAttachment: PasskeyAuthenticatorAttachment? = nil,
  ) {
    self.name = name
    self.authenticatorAttachment = authenticatorAttachment
  }
}

public typealias PasskeyAddPasskeyResponse = PasskeyVerifyRegistrationResponse

public struct PasskeyGenerateRegisterOptionsRequest: Codable, Sendable {
  public let name: String?
  public let authenticatorAttachment: PasskeyAuthenticatorAttachment?

  public init(
    name: String? = nil,
    authenticatorAttachment: PasskeyAuthenticatorAttachment? = nil
  ) {
    self.name = name
    self.authenticatorAttachment = authenticatorAttachment
  }
}

public struct PasskeyPublicKeyCredentialRpEntity: Codable, Sendable {
  public let id: String?
  public let name: String

  public init(id: String? = nil, name: String) {
    self.id = id
    self.name = name
  }
}

public struct PasskeyPublicKeyCredentialUserEntity: Codable, Sendable {
  public let id: String
  public let name: String
  public let displayName: String

  public init(id: String, name: String, displayName: String) {
    self.id = id
    self.name = name
    self.displayName = displayName
  }
}

public enum PasskeyPublicKeyCredentialType: String, Codable, Sendable {
  case publicKey = "public-key"
}

public struct PasskeyPublicKeyCredentialParameters: Codable, Sendable {
  public let alg: Int
  public let type: PasskeyPublicKeyCredentialType

  public init(alg: Int, type: PasskeyPublicKeyCredentialType) {
    self.alg = alg
    self.type = type
  }
}

public enum PasskeyAuthenticatorTransportFuture: String, Codable, Sendable {
  case ble
  case cable
  case hybrid
  case `internal`
  case nfc
  case smartCard = "smart-card"
  case usb
}

public struct PasskeyPublicKeyCredentialDescriptor: Codable, Sendable {
  public let id: String
  public let type: PasskeyPublicKeyCredentialType
  public let transports: [PasskeyAuthenticatorTransportFuture]

  public init(
    id: String,
    type: PasskeyPublicKeyCredentialType,
    transports: [PasskeyAuthenticatorTransportFuture] = []
  ) {
    self.id = id
    self.type = type
    self.transports = transports
  }
}

public enum PasskeyResidentKey: String, Codable, Sendable {
  case discouraged
  case preferred
  case required
}

public enum PasskeyUserVerificationRequirement: String, Codable, Sendable {
  case discouraged
  case preferred
  case required
}

public struct PasskeyAuthenticatorSelectionCriteria: Codable, Sendable {
  public let authenticatorAttachment: PasskeyAuthenticatorAttachment?
  public let requiresResidentKey: Bool?
  public let residentKey: PasskeyResidentKey?
  public let userVerification: PasskeyUserVerificationRequirement?

  public init(
    authenticatorAttachment: PasskeyAuthenticatorAttachment? = nil,
    requiresResidentKey: Bool? = nil,
    residentKey: PasskeyResidentKey? = nil,
    userVerification: PasskeyUserVerificationRequirement? = nil
  ) {
    self.authenticatorAttachment = authenticatorAttachment
    self.requiresResidentKey = requiresResidentKey
    self.residentKey = residentKey
    self.userVerification = userVerification
  }
}

public enum PasskeyPublicKeyCredentialHint: String, Codable, Sendable {
  case hybrid
  case securityKey = "security-key"
  case clientDevice = "client-device"
}

public enum PasskeyAttestationConveyancePreference: String, Codable, Sendable {
  case direct
  case indirect
  case enterprise
  case none
}

public enum PasskeyAttestationFormats: String, Codable, Sendable {
  case fidoU2f = "fido-u2f"
  case packed
  case androidSafetynet = "android-safetynet"
  case androidKey = "android-key"
  case tpm
  case apple
  case none
}

public struct PasskeyAuthenticationExtensionsClientInputs: Codable, Sendable {
  public let appid: String?
  public let credProps: Bool?
  public let hmacCreateSecret: Bool?
  public let minPinLength: Bool?

  public init(
    appid: String? = nil,
    credProps: Bool? = nil,
    hmacCreateSecret: Bool? = nil,
    minPinLength: Bool? = nil
  ) {
    self.appid = appid
    self.credProps = credProps
    self.hmacCreateSecret = hmacCreateSecret
    self.minPinLength = minPinLength
  }
}

public struct PasskeyGenerateRegisterOptionsResponse: Codable, Sendable {
  public let rp: PasskeyPublicKeyCredentialRpEntity
  public let user: PasskeyPublicKeyCredentialUserEntity
  public let challenge: String
  public let pubKeyCredParams: [PasskeyPublicKeyCredentialParameters]
  public let timeout: Int?
  public let excludeCredentials: [PasskeyPublicKeyCredentialDescriptor]?
  public let authenticatorSelection: PasskeyAuthenticatorSelectionCriteria?
  public let hints: [PasskeyPublicKeyCredentialHint]?
  public let attestation: PasskeyAttestationConveyancePreference?
  public let attestationFormats: [PasskeyAttestationFormats]?
  public let extensions: PasskeyAuthenticationExtensionsClientInputs?

  public init(
    rp: PasskeyPublicKeyCredentialRpEntity,
    user: PasskeyPublicKeyCredentialUserEntity,
    challenge: String,
    pubKeyCredParams: [PasskeyPublicKeyCredentialParameters],
    timeout: Int? = nil,
    excludeCredentials: [PasskeyPublicKeyCredentialDescriptor]? = nil,
    authenticatorSelection: PasskeyAuthenticatorSelectionCriteria? = nil,
    hints: [PasskeyPublicKeyCredentialHint]? = nil,
    attestation: PasskeyAttestationConveyancePreference? = nil,
    attestationFormats: [PasskeyAttestationFormats]? = nil,
    extensions: PasskeyAuthenticationExtensionsClientInputs? = nil
  ) {
    self.rp = rp
    self.user = user
    self.challenge = challenge
    self.pubKeyCredParams = pubKeyCredParams
    self.timeout = timeout
    self.excludeCredentials = excludeCredentials
    self.authenticatorSelection = authenticatorSelection
    self.hints = hints
    self.attestation = attestation
    self.attestationFormats = attestationFormats
    self.extensions = extensions
  }
}

public struct PasskeyAuthenticatorAttestationResponse: Codable, Sendable {
  public let clientDataJSON: String
  public let attestationObject: String?
  public let authenticatorData: String?
  public let transports: [PasskeyAuthenticatorTransportFuture]
  public let publicKeyAlgorithm: Int?
  public let publicKey: String?

  public init(
    clientDataJSON: String,
    attestationObject: String?,
    authenticatorData: String? = nil,
    transports: [PasskeyAuthenticatorTransportFuture] = [],
    publicKeyAlgorithm: Int? = nil,
    publicKey: String? = nil
  ) {
    self.clientDataJSON = clientDataJSON
    self.attestationObject = attestationObject
    self.authenticatorData = authenticatorData
    self.transports = transports
    self.publicKeyAlgorithm = publicKeyAlgorithm
    self.publicKey = publicKey
  }
}

public struct PasskeyCredentialPropertiesOutput: Codable, Sendable {
  public let rk: Bool?

  public init(rk: Bool? = nil) {
    self.rk = rk
  }
}

public struct PasskeyAuthenticationExtensionsClientOutputs: Codable, Sendable {
  public let appid: Bool?
  public let credProps: PasskeyCredentialPropertiesOutput?
  public let hmacCreateSecret: Bool?

  public init(
    appid: Bool? = nil,
    credProps: PasskeyCredentialPropertiesOutput? = nil,
    hmacCreateSecret: Bool? = nil
  ) {
    self.appid = appid
    self.credProps = credProps
    self.hmacCreateSecret = hmacCreateSecret
  }
}

public struct PasskeyRegistrationResponse: Codable, Sendable {
  public let id: String
  public let rawId: String
  public let response: PasskeyAuthenticatorAttestationResponse
  public let authenticatorAttachment: PasskeyAuthenticatorAttachment?
  public let clientExtensionResults:
    PasskeyAuthenticationExtensionsClientOutputs
  public let type: PasskeyPublicKeyCredentialType

  public init(
    id: String,
    rawId: String,
    response: PasskeyAuthenticatorAttestationResponse,
    authenticatorAttachment: PasskeyAuthenticatorAttachment? = nil,
    clientExtensionResults: PasskeyAuthenticationExtensionsClientOutputs,
    type: PasskeyPublicKeyCredentialType
  ) {
    self.id = id
    self.rawId = rawId
    self.response = response
    self.authenticatorAttachment = authenticatorAttachment
    self.clientExtensionResults = clientExtensionResults
    self.type = type
  }
}

public struct PasskeyVerifyRegistrationRequest: Codable, Sendable {
  public let response: PasskeyRegistrationResponse
  public let name: String?

  public init(response: PasskeyRegistrationResponse, name: String? = nil) {
    self.response = response
    self.name = name
  }
}

public enum PasskeyDeviceType: String, Codable, Sendable {
  case singleDevice
  case multiDevice
}

public struct PasskeyVerifyRegistrationResponse: Codable, Sendable {
  public let id: String
  public let name: String?
  public let publicKey: String
  public let userId: String
  public let credentialID: String
  public let counter: Int
  public let deviceType: PasskeyDeviceType
  public let backedUp: Bool
  public let transports: String?
  public let createdAt: Date
  public let aaguid: String?

  public init(
    id: String,
    name: String? = nil,
    publicKey: String,
    userId: String,
    credentialID: String,
    counter: Int,
    deviceType: PasskeyDeviceType,
    backedUp: Bool,
    transports: String? = nil,
    createdAt: Date,
    aaguid: String? = nil
  ) {
    self.id = id
    self.name = name
    self.publicKey = publicKey
    self.userId = userId
    self.credentialID = credentialID
    self.counter = counter
    self.deviceType = deviceType
    self.backedUp = backedUp
    self.transports = transports
    self.createdAt = createdAt
    self.aaguid = aaguid
  }
}

public struct PasskeyGenerateAuthenticateOptionsResponse: Codable, Sendable {
  public let challenge: String
  public let timeout: Int?
  public let rpId: String?
  public let allowCredentials: [PasskeyPublicKeyCredentialDescriptor]?
  public let userVerification: PasskeyUserVerificationRequirement?
  public let hints: [PasskeyPublicKeyCredentialHint]?
  public let extensions: PasskeyAuthenticationExtensionsClientInputs?

  public init(
    challenge: String,
    timeout: Int? = nil,
    rpId: String? = nil,
    allowCredentials: [PasskeyPublicKeyCredentialDescriptor]? = nil,
    userVerification: PasskeyUserVerificationRequirement? = nil,
    hints: [PasskeyPublicKeyCredentialHint]? = nil,
    extensions: PasskeyAuthenticationExtensionsClientInputs? = nil
  ) {
    self.challenge = challenge
    self.timeout = timeout
    self.rpId = rpId
    self.allowCredentials = allowCredentials
    self.userVerification = userVerification
    self.hints = hints
    self.extensions = extensions
  }
}

public struct PasskeyAuthenticatorAssertionResponse: Codable, Sendable {
  public let clientDataJSON: String
  public let authenticatorData: String
  public let signature: String
  public let userHandle: String?

  public init(
    clientDataJSON: String,
    authenticatorData: String,
    signature: String,
    userHandle: String? = nil
  ) {
    self.clientDataJSON = clientDataJSON
    self.authenticatorData = authenticatorData
    self.signature = signature
    self.userHandle = userHandle
  }
}

public struct PasskeyAuthenticationResponse: Codable, Sendable {
  public let id: String
  public let rawId: String
  public let response: PasskeyAuthenticatorAssertionResponse
  public let authenticatorAttachment: PasskeyAuthenticatorAttachment?
  public let clientExtensionResults:
    PasskeyAuthenticationExtensionsClientOutputs
  public let type: PasskeyPublicKeyCredentialType

  public init(
    id: String,
    rawId: String,
    response: PasskeyAuthenticatorAssertionResponse,
    authenticatorAttachment: PasskeyAuthenticatorAttachment? = nil,
    clientExtensionResults: PasskeyAuthenticationExtensionsClientOutputs,
    type: PasskeyPublicKeyCredentialType
  ) {
    self.id = id
    self.rawId = rawId
    self.response = response
    self.authenticatorAttachment = authenticatorAttachment
    self.clientExtensionResults = clientExtensionResults
    self.type = type
  }
}

public struct PasskeyVerifyAuthenticationRequest: Codable, Sendable {
  public let response: PasskeyAuthenticationResponse

  public init(response: PasskeyAuthenticationResponse) {
    self.response = response
  }
}

public struct PasskeyVerifyAuthenticationResponse: Codable, Sendable {
  public let session: SessionData

  public init(session: SessionData) {
    self.session = session
  }
}
