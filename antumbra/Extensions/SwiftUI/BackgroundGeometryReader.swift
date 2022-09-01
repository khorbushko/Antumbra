//
//  BackgroundGeometryReader.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 21.08.2022.
//

import Foundation
import SwiftUI

struct BackgroundGeometryReader: View {
  struct SizePreferenceKey: PreferenceKey {
    public typealias Value = CGSize
    public static var defaultValue: Value = .zero

    public static func reduce(value: inout Value, nextValue: () -> Value) {
      value = nextValue()
    }
  }

  public init() {}

  public var body: some View {
    GeometryReader { geometry in
      return Color
        .clear
        .preference(key: SizePreferenceKey.self, value: geometry.size)
    }
  }
}
