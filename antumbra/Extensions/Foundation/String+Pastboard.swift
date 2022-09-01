//
//  String+Pastboard.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 21.08.2022.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension String {
  func copyToPastboard() {
#if os(macOS)
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(self, forType: .string)
#else
    UIPasteboard.general.string = self
#endif
  }
}
