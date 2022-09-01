//
//  Icon.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct Icon {
  public let name: String
  private let bundle: Bundle?

  // MARK: - LifeCycle

  public init(_ value: String, bundle: Bundle? = nil) {
    self.bundle = bundle
    self.name = value
  }
}

extension Icon {
  // MARK: - Icon+UIKit

#if os(macOS)
  public var kitImage: NSImage? {
    let image = bundle?.image(forResource: name) ?? NSImage(named: name)
    assert(image != nil, "image are missed for specified image name")

    return image
  }
#else
  public var kitImage: UIImage? {
    let image = UIImage(named: name, bundle: bundle)
    assert(image != nil, "image are missed for specified image name")

    return image
  }
#endif
}

extension Icon {
  // MARK: - Icon+SwiftUI

  public var image: Image {
    let image = Image(name, bundle: bundle)
    return image
  }
}

extension Icon: Hashable { }
extension Icon: Equatable {
  public static func == (lhs: Icon, rhs: Icon) -> Bool {
    lhs.name == rhs.name &&
    lhs.bundle?.bundlePath == rhs.bundle?.bundlePath
  }
}
