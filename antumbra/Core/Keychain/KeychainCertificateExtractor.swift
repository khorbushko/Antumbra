//
//  KeychainCertificateExtractor.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 31.08.2022.
//

import Foundation
import Security
import Combine

final class KeychainCertificateExtractor {

  static func extractAllCertificates() -> [KeychainCertificate] {
    var certificates: [KeychainCertificate] = []

    var copyResult: CFTypeRef?
    let extractItemsErr = SecItemCopyMatching(
      [
        kSecClass: kSecClassIdentity,
        kSecMatchLimit: kSecMatchLimitAll,
        kSecReturnRef: true
      ] as NSDictionary,
      &copyResult
    )

    if extractItemsErr == errSecSuccess,
       let identities = copyResult as? [SecIdentity] {
      for identity in identities {
        var certificate: SecCertificate?
        let certCopyErr = SecIdentityCopyCertificate(identity, &certificate)
        if certCopyErr == errSecSuccess,
           let certificate = certificate {

          let certificate = KeychainCertificate(
            certificate: certificate
          )

          certificates.append(certificate)
        }
      }
    }

    return certificates
  }

  static func fetchAll() -> AnyPublisher<[KeychainCertificate], Never> {
    Deferred {
      Future { promise in
        let certs = Self.extractAllCertificates()
        promise(.success(certs))
      }
    }
    .eraseToAnyPublisher()
  }

  static func fetchAllAPNS() -> AnyPublisher<[KeychainCertificate], Never> {
    fetchAll()
      .map { cert in
        cert
          .filter { $0.isAPNS }
      }
      .eraseToAnyPublisher()
  }
}
