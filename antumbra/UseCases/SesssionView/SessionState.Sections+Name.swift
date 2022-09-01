//
//  SessionState.Sections+Name.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 21.08.2022.
//

import Foundation

extension SessionState.Sections {
  var title: String {
    switch self {
      case .auth:
        return Localizator.Session.Section.auth
      case .destination:
        return Localizator.Session.Section.destination
      case .body:
        return Localizator.Session.Section.body
      case .header:
        return Localizator.Session.Section.header
      case .environment:
        return Localizator.Session.Section.env
    }
  }
}
