//
//  NSApplication+SideBar.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import AppKit
import Combine

extension NSApplication {
  static func toogleSideBar() -> AnyPublisher<Void, Never> {
    Deferred {
      Future { promise in

        NSApp.keyWindow?.firstResponder?
          .tryToPerform(
            #selector(NSSplitViewController.toggleSidebar(_:)),
            with: nil
          )

        promise(.success(()))
      }
    }
    .eraseToAnyPublisher()
  }
}
