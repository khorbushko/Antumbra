//
//  View+TapArea.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI

extension View {
  func increaseTapArea() -> some View {
    self.contentShape(Rectangle())
  }
}
