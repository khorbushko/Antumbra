//
//  Session.PushData.PushEnvironment+Path.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

extension Session.PushData.PushEnvironment {

    var endPoint: String {
      switch self {
        case .sandbox:
          return "https://api.sandbox.push.apple.com:443"
        case .production:
          return "https://api.push.apple.com:443"
      }
    }
}
