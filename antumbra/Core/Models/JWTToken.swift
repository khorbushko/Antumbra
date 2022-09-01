//
//  JWTToken.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

/// Represent JSON WebToken for OpenID
///
/// JWTs (JSON Web Tokens) are split into three pieces:

/// - **Header** - Provides information about how to validate the token including
///  information about the type of token and how it was signed.
/// - **Payload** - Contains all of the important data about the user
/// or app that is attempting to call your service.
/// - **Signature** - Is the raw material used to validate the token.
///
/// Each piece is separated by a period (.) and separately Base64 encoded.
///
public struct JWTToken: Codable, Equatable, Hashable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.raw == rhs.raw
  }

  public enum Kind: String, CaseIterable, Codable, Equatable, Hashable {
    case access
    case refresh
    case id
  }

  public enum Failure: Swift.Error {
    case unexpectedFormat
    case tokenPartsInvalidURLDecode
    case invalidJSON
  }

  // MARK: - Raw

  public let type: Kind
  public let raw: String

  // MARK: - Components

  /// information about how to validate the token including
  /// information about the type of token and how it was signed
  var header: [String: Any]? {
    let parts = raw.components(separatedBy: ".")
    if parts.count == 3,
       let rawHeaderData = parts[0].base64UrlDecode {
      return try? rawHeaderData.decodeJWTPart()
    }
    return nil
  }

  /// Contains all of the important data about the user or app that
  /// is attempting to call your service.
  ///
  /// [read more here](https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens#payload-claims)
  var body: [String: Any]? {
    let parts = raw.components(separatedBy: ".")
    if parts.count == 3,
       let rawBodyData = parts[1].base64UrlDecode {
      return try? rawBodyData.decodeJWTPart()
    }
    return nil
  }

  /// Is the raw material used to validate the token
  var signature: String? {
    let parts = raw.components(separatedBy: ".")
    if parts.count == 3 {
      return parts[2]
    }
    return nil
  }

  // MARK: - Values

  public var signAlgorithm: String? {
    header?["alg"] as? String
  }

  public var thumbprint: String? {
    header?["kid"] as? String
  }

  public var issuer: String? {
    body?["iss"] as? String
  }

  public var subject: String? {
    body?["sub"] as? String
  }

  public var audience: String? {
    body?["aud"] as? String
  }

  public var name: String? {
    body?["name"] as? String
  }

  public var givenName: String? {
    body?["given_name"] as? String
  }

  public var familyName: String? {
    body?["family_name"] as? String
  }

  public var identifier: String? {
    body?["jti"] as? String
  }

  public var scopes: String? {
    body?["scp"] as? String
  }

  public var version: String? {
    body?["ver"] as? String
  }

  public var tenantId: String? {
    body?["tid"] as? String
  }

  public var expiresAt: Date? {
    claimAsDate(for: "exp")
  }

  public var issuedAt: Date? {
    claimAsDate(for: "iat")
  }

  public var notBefore: Date? {
    claimAsDate(for: "nbf")
  }

  public var isExpired: Bool {
    if let expiresAt = self.expiresAt {
      return expiresAt.compare(Date()) != .orderedDescending
    } else {
      return false
    }
  }

  // MARK: - Lifecycle

  public init(
    raw: String,
    type: Kind
  ) throws {
    let parts = raw.components(separatedBy: ".")
    if parts.count == 3 {
      self.raw = raw
      self.type = type
    } else {
      throw Failure.unexpectedFormat
    }
  }

  // MARK: - Private

  private func claimAsDate(for key: String) -> Date? {
    if let timeStamp = body?[key] as? TimeInterval {
      return Date(timeIntervalSince1970: timeStamp)
    }

    return nil
  }
}

fileprivate extension Data {
  func decodeJWTPart() throws -> [String: Any] {
    let json = try JSONSerialization.jsonObject(with: self, options: [])
    return json as? [String: Any] ?? [: ]
  }
}

fileprivate extension String {
  var base64UrlDecode: Data? {
    var base64 = self
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")

    let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length

    if paddingLength > 0 {
      let padding = "".padding(
        toLength: Int(paddingLength),
        withPad: "=",
        startingAt: 0
      )
      base64 += padding
    }

    return Data(
      base64Encoded: base64,
      options: .ignoreUnknownCharacters
    )
  }
}
