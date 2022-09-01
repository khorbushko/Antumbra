//
//  ExpandableView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 20.08.2022.
//

import Foundation
import SwiftUI

struct ExpandableView<C: View>: View {
  let title: String
  @Binding var expand: Bool
  @ViewBuilder let content: () -> C

  var body: some View {
    VStack {
      HStack {
        Text(title)
          .adaptiveFont(.appBold, size: 12)
          .foregroundColor(.app.Text.hightlighed.opacity(0.5))
          .frame(height: 44)
        Spacer()
      }
      .frame(height: 44)
      .overlay(
        HStack {
          Spacer()
          Image(systemName: "arrow.down.circle")
            .rotationEffect(expand ? .zero : .degrees(180))
            .animation(.linear, value: expand)
            .frame(width: 44, height: 44)
        }
          .increaseTapArea()
          .onTapGesture {
            withAnimation(.linear(duration: 0.3)) {
              expand.toggle()
            }
          }
      )
      .frame(height: 44)

      if expand {
        VStack(spacing: 6) {
          content()
            .transition(.opacity)
        }
        Spacer(minLength: 16)
      }

    }
    .padding(.horizontal)
    .frame(height: expand ? nil : 44)
    .background(Color.app.Background.secondary)
    .roundedCorners(
      radius: 6,
      corners: .allCorners
    )
    .padding(.bottom, 4)
  }
}
