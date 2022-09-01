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

  var validity: (notValidBefore: Date, notValidAfter:Date)? {
    if let decodedString = String(
      data: data as Data,
      encoding: .ascii
    ) {
      var foundWWDRCA = false
      var notValidBeforeDate = ""
      var notValidAfterDate = ""

      decodedString.enumerateLines { (line, _) in
        if foundWWDRCA && (notValidBeforeDate.isEmpty || notValidAfterDate.isEmpty) {
          let certificateData = line.prefix(13)
          if notValidBeforeDate.isEmpty && !certificateData.isEmpty {
            notValidBeforeDate = String(certificateData)
          } else if notValidAfterDate.isEmpty && !certificateData.isEmpty {
            notValidAfterDate = String(certificateData)
          }
        }

        if line.contains("Apple Worldwide Developer Relations Certification Authority") {
          foundWWDRCA = true
        }
      }

      if let notValidBeforeDate = format(notValidBeforeDate),
         let notValidAfterDate = format(notValidAfterDate) {

        return (notValidBeforeDate, notValidAfterDate)
      }
    }

    return nil
  }

  var expireAt: String? {
    if let validity = validity {
      let expireDate = validity.notValidAfter
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMM YYYY"
      let value = formatter.string(from: expireDate)
      return value
    }
    return nil
  }

  var isAPNS: Bool {
    name?.contains("Push") == true
  }

  private static let certificateDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMddHHmmssZ"
    return formatter
  }()

  private func format(_ date:String) -> Date? {
    Self.certificateDateFormatter.date(from: date)
  }
}
