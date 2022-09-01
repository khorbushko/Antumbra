//
//  PushPredefinedType+Name.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 24.08.2022.
//

import Foundation

extension PushPredefinedType {
  var name: String {
    switch self {
      case .simple:
        return Localizator.Session.PushPredefinedType.simple
      case .localized:
        return Localizator.Session.PushPredefinedType.localized
      case .customData:
        return Localizator.Session.PushPredefinedType.customData
      case .alert:
        return Localizator.Session.PushPredefinedType.alert
      case .badge:
        return Localizator.Session.PushPredefinedType.badge
      case .sound:
        return Localizator.Session.PushPredefinedType.sound
      case .backgroundUpdate:
        return Localizator.Session.PushPredefinedType.backgroundUpdate
      case .actions:
        return Localizator.Session.PushPredefinedType.actions
      case .critical:
        return Localizator.Session.PushPredefinedType.critical
      case .silent:
        return Localizator.Session.PushPredefinedType.silent
      case .mutableContent:
        return Localizator.Session.PushPredefinedType.mutableContent
    }
  }
}
