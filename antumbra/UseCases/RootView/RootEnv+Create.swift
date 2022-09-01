//
//  RootEnv+Create.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import AppKit
import ComposableArchitecture

extension RootEnvironment {

  static let live: Self = {
    .init(
      workQueue: .main,
      sideBarEnvironment: .live,
      toogleToolbarAction: NSApplication.toogleSideBar
    )
  }()

  static let preview: Self = {
    .init(
      workQueue: .main,
      sideBarEnvironment: .preview,
      toogleToolbarAction: NSApplication.toogleSideBar
    )
  }()
}
