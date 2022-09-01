//
//  Session+Request.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

extension Session {
  var headers: [String : String] {
    var headers = [
      "Content-Type": "application/json",
      "apns-priority": "\(self.priority.rawValue)",
      "apns-push-type": self.kind.rawValue
    ]

    if let bundleID = self.bundleId {
      headers["apns-topic"] = bundleID
    }

    if let expiration = self.expiration {
      headers["apns-expiration"] = expiration
    }
    if let topicId = self.notificationId {
      headers["apns-id"] = topicId
    }
    if let collapseId = self.collapseId {
      headers["apns-collapse-id"] = collapseId
    }

    return headers
  }

  var endPoint: URL? {
    if let apnsToken = self.apnsToken {
      let urlString = "\(self.environment.endPoint)/3/device/\(apnsToken)"
      if let url = URL(string: urlString) {
        return url
      }
    }

    return nil
  }

  var payloadData: Data? {
    let payloadDictionaryData = try? self.pushData.pushMessage
      .toDictionary()
      .toData()
    return payloadDictionaryData
  }
}
