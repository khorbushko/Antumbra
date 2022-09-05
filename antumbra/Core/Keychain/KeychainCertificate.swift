//
//  KeychainCertificate.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 31.08.2022.
//

import Foundation
import Security

struct KeychainCertificate: Equatable, Hashable {
  let certificate: SecCertificate

  var name: String? {
    SecCertificateCopySubjectSummary(certificate) as? String
  }

  var summary: String? {
    SecCertificateCopySubjectSummary(certificate) as? String
  }

  var data: CFData {
    SecCertificateCopyData(certificate)
  }

  var identity: SecIdentity? {
    var identityInst: SecIdentity?
    let copyStatus = SecIdentityCreateWithCertificate(
      nil,
      certificate,
      &identityInst
    )
    if copyStatus == errSecSuccess,
       let identityInst = identityInst {
      return identityInst
    }

    return nil
  }

  var key: SecKey? {
    var keyInst: SecKey?
    if let identity = identity {
      let keystat: OSStatus = SecIdentityCopyPrivateKey(identity, &keyInst)
      if keystat == errSecSuccess,
         let keyInst = keyInst {
        return keyInst
      }
    }

    return nil
  }

  var expireAtDate: Date? {
    let data = SecCertificateCopyValues(certificate, nil, nil)
    let valueRaw = CFDictionaryGetValue(
      data,
      unsafeBitCast(kSecOIDX509V1ValidityNotAfter, to: UnsafeRawPointer.self)
    )
    let value = unsafeBitCast(
      valueRaw,
      to: NSDictionary.self
    )
    if let timeInterval = value["value"] as? TimeInterval {
      let date = Date(timeIntervalSinceReferenceDate: timeInterval)
      return date
    }

    return nil
  }

  var isAPNS: Bool {
    name?.contains("Push") == true
  }
}

extension KeychainCertificate {
  var expireAtReadableString: String? {
    if let expireAtDate = expireAtDate {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMM YYYY"
      let value = formatter.string(from: expireAtDate)
      return value

    }
    return nil
  }
}
