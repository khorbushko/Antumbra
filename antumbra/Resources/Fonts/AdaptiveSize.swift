//
//  AdaptiveSize.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation
import SwiftUI

extension CGFloat {
  public static func grid(_ n: Int) -> Self {
    Self(n) * 4
  }
}

public enum AdaptiveSize {
  case small
  case medium
  case large

  public var padding: CGFloat {
    switch self {
      case .small:
        return 0
      case .medium:
        return .grid(1)
      case .large:
        return .grid(2)
    }
  }
}

extension EnvironmentValues {
  public var adaptiveSize: AdaptiveSize {
    get { self[AdaptiveSizeKey.self] }
    set { self[AdaptiveSizeKey.self] = newValue }
  }
}

private struct AdaptiveSizeKey: EnvironmentKey {
  static var defaultValue: AdaptiveSize {
    .medium
  }
}
