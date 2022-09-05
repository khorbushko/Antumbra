//
//  CertView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 31.08.2022.
//

import Foundation
import SwiftUI

struct CertView: View {
  let element: KeychainCertificate
  let isSelected: Bool
  let backgroundColor: Color

  var body: some View {
    HStack(spacing: 0) {

      VStack(alignment: .leading, spacing: 0) {
        Spacer(minLength: 0)
        Text(element.name ?? .dash)
          .foregroundColor(Color.app.Text.primary)
          .adaptiveFont(.appRegular, size: 8)

        Spacer(minLength: 0)
      }
      .padding(.horizontal, 8)

      Spacer(minLength: 0)

      VStack(spacing: 0) {
        VStack(alignment: .trailing, spacing: 2) {
          Spacer(minLength: 0)
          Text(Localizator.Session.CertTab.expires)
            .foregroundColor(Color.app.Text.primary.opacity(0.5))
            .adaptiveFont(.appRegular, size: 6)

          Text(element.expireAtReadableString ?? .dash)
            .foregroundColor(Color.app.Text.primary)
            .adaptiveFont(.appRegular, size: 6)
          Spacer(minLength: 0)
        }
      }
      .padding(.horizontal, 8)
    }
    .background(backgroundColor)
    .frame(height: 32)
    .overlay(
      HStack {
        Divider()
          .frame(width: isSelected ? 3 : 0)
          .background(Color.app.Hightlight.indicator)
        Spacer()
      }
    )
  }
}
