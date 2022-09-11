//
//  CheckboxView.swift
//  antumbra
//
//  Created by Kyrylo Horbushko on 11.09.2022.
//

import Foundation
import SwiftUI

struct CheckboxFieldView<C: View>: View {
  internal init(
    activeColor: Color,
    inactiveColor: Color,
    activeImage: Image = Image(systemName: "checkmark.circle"),
    inactiveImage: Image = Image(systemName: "circle"),
    checkState: Binding<Bool>,
    content: @escaping () -> C
  ) {
    self.activeColor = activeColor
    self.inactiveColor = inactiveColor
    self.activeImage = activeImage
    self.inactiveImage = inactiveImage
    self.checkState = checkState
    self.content = content
  }

  private let activeColor: Color
  private let inactiveColor: Color
  private let activeImage: Image
  private let inactiveImage: Image
  private let checkState: Binding<Bool>
  @ViewBuilder private let content: () -> C

  var body: some View {
    Button(action: {
      checkState.wrappedValue.toggle()
    }) {
      HStack(alignment: .center, spacing: 10) {
        let image = checkState.wrappedValue
        ? activeImage
        : inactiveImage

        image
          .resizable()
          .frame(width:12, height:12)
          .foregroundColor(
            checkState.wrappedValue
            ? activeColor
            : inactiveColor
          )

        content()
      }
    }
    .increaseTapArea()
    .buttonStyle(.borderless)
  }
}
