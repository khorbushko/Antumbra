//
//  PushEnvironment.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation

enum PushEnvironment: Codable, Hashable {
  case sandbox
  case production

  var url: String {
    switch self {
      case .sandbox:
        return "https://api.sandbox.push.apple.com:443"
      case .production:
        return "https://api.push.apple.com:443"
    }
  }
}
