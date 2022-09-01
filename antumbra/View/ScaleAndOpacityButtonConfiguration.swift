//
//  ScaleAndOpacityButtonConfiguration.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 20.08.2022.
//

import Foundation
import SwiftUI

public enum ScaleAndOpacityConfigurator {
  case primary
  case secondary

  var selectedBackgroundColor: Color {
    switch self {
      case .primary:
        return Color.app.Control.Background.primary
      case .secondary:
        return Color.app.Control.Background.secondary
    }
  }

  var backgroundColor: Color {
    switch self {
      case .primary:
        return Color.app.Control.Background.primary
      case .secondary:
        return Color.app.Control.Background.secondary
    }
  }

  var disableOverlayColor: Color {
    switch self {
      case .primary:
        return Color.app.Image.primary.opacity(0.5)
      case .secondary:
        return Color.app.Image.primary.opacity(0.5)
    }
  }

  var selectedForegroundColor: Color {
    switch self {
      case .primary:
        return Color.app.Control.Tint.primary
      case .secondary:
        return Color.app.Control.Tint.primary
    }
  }

  var foregroundColor: Color {
    switch self {
      case .primary:
        return Color.app.Control.Tint.primary
      case .secondary:
        return Color.app.Control.Tint.secondary
    }
  }

  var disabledForegroundColor: Color {
    switch self {
      case .primary:
        return Color.app.Control.Tint.primary
      case .secondary:
        return Color.app.Control.Tint.secondary
    }
  }
}

public struct ScaleAndOpacityButtonStyleNoAnimation: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled: Bool
  private let buttonStyle: ScaleAndOpacityConfigurator
  private let hPadding: CGFloat

  public init(
    type: ScaleAndOpacityConfigurator,
    hPadding: CGFloat = 0
  ) {
    buttonStyle = type
    self.hPadding = hPadding
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .adaptiveFont(.appRegular, size: 16)
      .minimumScaleFactor(0.8)
      .frame(minWidth: 0, maxWidth: .infinity)
      .frame(height: 32)
      .cornerRadius(6)
      .background(
        isEnabled
        ? (configuration.isPressed
           ? buttonStyle.selectedBackgroundColor
           : buttonStyle.backgroundColor)
        : buttonStyle.disableOverlayColor
      )
      .foregroundColor(
        isEnabled
        ? (configuration.isPressed
           ? buttonStyle.selectedForegroundColor
           : buttonStyle.foregroundColor)
        : buttonStyle.disabledForegroundColor
      )
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .padding(.horizontal, hPadding)
      .opacity(configuration.isPressed ? 0.9 : 1)
      .scaleEffect(configuration.isPressed ? 0.98 : 1)
  }
}
