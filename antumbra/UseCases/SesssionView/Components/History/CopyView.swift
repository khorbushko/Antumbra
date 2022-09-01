//
//  CopyView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 29.08.2022.
//

import Foundation
import SwiftUI

struct CopyView: View {
  let title: String
  let value: String
  let onCopyAction: (String) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Button {
        onCopyAction(value)
      } label: {
        HStack(spacing: 2) {

          Text(title)
            .foregroundColor(Color.app.Text.primary)
            .adaptiveFont(.appRegular, size: 8)

          Image.Session.General.copy
            .renderingMode(.template)
            .resizable()
            .frame(width: 8, height: 10)
            .foregroundColor(Color.app.Image.secondary)

          Spacer(minLength: 0)

        }
      }
      .increaseTapArea()
      .buttonStyle(PlainButtonStyle())

      Text(value)
        .foregroundColor(Color.app.Text.primary.opacity(0.5))
        .adaptiveFont(.appRegular, size: 6)
    }
    .padding(.bottom, 12)
  }
}
