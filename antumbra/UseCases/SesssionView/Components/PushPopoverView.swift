//
//  PushPopoverView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 21.08.2022.
//

import Foundation
import SwiftUI

struct PopoverView: View {
  let kind: PopoverInfo

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 4) {
        Text(kind.title)
          .foregroundColor(Color.app.Text.hightlighed)
          .adaptiveFont(.appBold, size: 12)

        Text(kind.description)
          .foregroundColor(Color.app.Text.primary)
          .adaptiveFont(.appRegular, size: 10)

        if let link = kind.link,
           let url = URL(string: link) {

          HStack(spacing: 0) {
            Text(Localizator.Session.Popover.Message.main)
              .foregroundColor(Color.app.Text.primary)
              .adaptiveFont(.appRegular, size: 10)

            Link(
              destination: url
            ) {
              HStack {
                Text(Localizator.Session.Popover.Message.suffix)
                  .foregroundColor(Color.app.Text.hightlighed)
                  .adaptiveFont(.appBold, size: 10)
              }
            }
          }
        }

        if let imageName = kind.imageName {
          Image(imageName)
            .resizable()
            .frame(width: 500, height: 260)
        }
      }
      .padding()
      .background(Color.app.Background.primary)
      .frame(maxWidth: 550)
    }
    .frame(minHeight: 200, maxHeight: 375)
    .padding(4)
    .background(Color.app.Background.primary)
  }
}
