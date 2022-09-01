//
//  AdaptiveFont.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation
import SwiftUI

public typealias FontName = String

extension View {
  func adaptiveFont(
    _ name: FontName,
    size: CGFloat,
    configure: @escaping (Font) -> Font = { $0 }
  ) -> some View {
    self.modifier(AdaptiveFont(name: name, size: size, configure: configure))
  }
}

private struct AdaptiveFont: ViewModifier {
  @Environment(\.adaptiveSize) private var adaptiveSize

  let name: String
  let size: CGFloat
  let configure: (Font) -> Font

  func body(content: Content) -> some View {
    content
      .font(
        configure(
          .custom(name, size: size + adaptiveSize.padding)
        )
      )
  }
}

public enum FontStyle {
  case bold
  case regular
  case italic
}

public struct FontFamily {
  public init(
    bold: String,
    regular: String,
    italic: String
  ) {
    self.bold = bold
    self.regular = regular
    self.italic = italic
  }

  public let bold: String
  public let regular: String
  public let italic: String

  public func fontFor(style: FontStyle) -> String {
    switch style {
      case .bold:
        return bold
      case .regular:
        return regular
      case .italic:
        return italic
    }
  }
}

public protocol AppFont {

  static var app: FontFamily { get }
}

extension AppFont {
  public func nsFont(_ style: FontStyle, size: CGFloat) -> NSFont {
    let name = Self.app.fontFor(style: style)
    return NSFont(name: name, size: size) ?? .systemFont(ofSize: size)
  }
}

extension View {
  public func adaptiveFont(
    size: CGFloat,
    family: FontFamily,
    style: FontStyle = .regular
  ) -> some View {
    self.adaptiveFont(
      family.fontFor(style: style),
      size: size,
      configure: { $0 }
    )
  }
}
