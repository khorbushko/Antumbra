//
//  LoadingButton.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation
import SwiftUI

public struct LoadingButton<ViewContent: View>: View  {

  public init(
    action: @escaping () -> Void,
    label: @escaping () -> ViewContent,
    isLoading: Bool,
    buttonStyle: ScaleAndOpacityConfigurator,
    padding: CGFloat = 16,
    enableExplicitAnimation: Bool = false
  ) {
    self.action = action
    self.label = label
    self.buttonStyle = buttonStyle
    self.isLoading = isLoading
    self.padding = padding
    self.enableExplicitAnimation = enableExplicitAnimation
  }

  private let action: () -> Void
  @ViewBuilder private let label: () -> ViewContent
  private var isLoading: Bool
  private let padding: CGFloat
  private let enableExplicitAnimation: Bool
  private let buttonStyle: ScaleAndOpacityConfigurator

  public var body: some View {
    Button(
      action: {
        if !isLoading {
          action()
        }
      },
      label: {
        label()
          .opacity(isLoading ? 0 : 1)
      }
    )
    .buttonStyle(
      ScaleAndOpacityButtonStyleNoAnimation(
        type: buttonStyle,
        hPadding: padding
      )
    )
    .allowsHitTesting(!isLoading)
    .overlay(
      Group {
        if isLoading {
          LoadingCirclesView(indicatorColor: buttonStyle.foregroundColor)
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 24)
            .cornerRadius(6)
            .foregroundColor(buttonStyle.foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
      }
    )
  }
}
