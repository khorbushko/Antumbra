//
//  Session.PushData.PushPriority+Name.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 22.08.2022.
//

import Foundation

extension Session.PushData.PushPriority {
  var name: String {
    switch self {
      case .low:
        return Localizator.Session.PushData.Priority.low
      case .normal:
        return Localizator.Session.PushData.Priority.normal
      case .critical:
        return Localizator.Session.PushData.Priority.critical
    }
  }
}

extension Session.PushData.PushType {
  var name: String {
    switch self {
      case .alert:
        return Localizator.Session.PushData.Kind.alert
      case .background:
        return Localizator.Session.PushData.Kind.background
      case .location:
        return Localizator.Session.PushData.Kind.location
      case .voip:
        return Localizator.Session.PushData.Kind.voip
      case .complication:
        return Localizator.Session.PushData.Kind.complication
      case .fileprovider:
        return Localizator.Session.PushData.Kind.fileprovider
      case .mdm:
        return Localizator.Session.PushData.Kind.mdm
    }
  }
}

extension Session.PushData.PushEnvironment {
  var name: String {
    switch self {
      case .sandbox:
        return Localizator.Session.PushData.Env.sandbox
      case .production:
        return Localizator.Session.PushData.Env.production
    }
  }
}
