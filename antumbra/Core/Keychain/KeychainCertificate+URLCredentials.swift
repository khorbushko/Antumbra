//
//  KeychainCertificate+URLCredentials.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 31.08.2022.
//

import Foundation
import Security

extension KeychainCertificate {
  var urlCredentials: URLCredential? {
    if let identity = identity {
      let credentials = URLCredential(
        identity: identity,
        certificates: [certificate],
        persistence: .forSession
      )
      return credentials
    }

    return nil
  }
}
