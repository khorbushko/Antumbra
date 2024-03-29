//
//  View+CornerRadius.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI

#if os(macOS)
struct RectCorner: OptionSet {

  let rawValue: Int

  static let topLeft = RectCorner(rawValue: 1 << 0)
  static let topRight = RectCorner(rawValue: 1 << 1)
  static let bottomRight = RectCorner(rawValue: 1 << 2)
  static let bottomLeft = RectCorner(rawValue: 1 << 3)

  static let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]

  static func cornersForElement(at index: Int, totalCount: Int) -> RectCorner {
    let isFirst = index == 0
    let isLast = index == totalCount-1
    let corners: RectCorner
    switch (isFirst, isLast) {
      case (true, true):
        corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
      case (true, false):
        corners = [.topLeft, .topRight]
      case (false, true):
        corners = [.bottomLeft, .bottomRight]
      default:
        corners = []
    }
    return corners
  }
}

struct RoundedCornersShape: Shape {

  var radius: CGFloat = .zero
  var corners: RectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    var path = Path()

    let p1 = CGPoint(
      x: rect.minX,
      y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY
    )
    let p2 = CGPoint(
      x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX,
      y: rect.minY
    )

    let p3 = CGPoint(
      x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX,
      y: rect.minY
    )
    let p4 = CGPoint(
      x: rect.maxX,
      y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY
    )

    let p5 = CGPoint(
      x: rect.maxX,
      y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY
    )
    let p6 = CGPoint(
      x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX,
      y: rect.maxY
    )

    let p7 = CGPoint(
      x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX,
      y: rect.maxY
    )
    let p8 = CGPoint(
      x: rect.minX,
      y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY
    )

    path.move(to: p1)
    path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                tangent2End: p2,
                radius: radius)
    path.addLine(to: p3)
    path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                tangent2End: p4,
                radius: radius)
    path.addLine(to: p5)
    path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                tangent2End: p6,
                radius: radius)
    path.addLine(to: p7)
    path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                tangent2End: p8,
                radius: radius)
    path.closeSubpath()

    return path
  }
}

extension View {
  func roundedCorners(radius: CGFloat, corners: RectCorner) -> some View {
    clipShape( RoundedCornersShape(radius: radius, corners: corners) )
  }
}

#endif
