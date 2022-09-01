//
//  HeaderView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 29.08.2022.
//

import Foundation
import SwiftUI

struct HeaderView: View {
  let key: String
  let value: String
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 4) {
        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: 0) {
            Text(key)
              .foregroundColor(Color.app.Text.primary.opacity(0.75))
              .adaptiveFont(.appRegular, size: 6)
              .minimumScaleFactor(0.5)
            Spacer(minLength: 0)
          }
          Spacer(minLength: 0)
        }
        .frame(width: 80)
        VStack(alignment: .leading, spacing: 0) {

          Text(value)
            .foregroundColor(Color.app.Text.primary.opacity(0.5))
            .adaptiveFont(.appRegular, size: 4)
          Spacer(minLength: 0)
        }
      }
    }
  }
}
