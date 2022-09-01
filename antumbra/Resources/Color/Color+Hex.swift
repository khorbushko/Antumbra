//
//  Color+Hex.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation
import SwiftUI

extension Color {
  public static func hex(_ hex: UInt) -> Self {
    Self(
      red: Double((hex & 0xff0000) >> 16) / 255.0,
      green: Double((hex & 0x00ff00) >> 8) / 255.0,
      blue: Double(hex & 0x0000ff) / 255.0,
      opacity: 1
    )
  }
}
