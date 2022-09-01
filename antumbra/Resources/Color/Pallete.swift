//
//  Colors.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI

extension Color {
  enum app {
    enum Background {
      static let primary = Color("background")
      static let secondary = Color("secondaryBackground")
    }

    enum State {
      static let success = Color.app.Hightlight.indicator
      static let failure = Color.app.Control.Background.primary
    }

    enum Hightlight {
      static let background = Color("selectionBackground")
      static let indicator = Color("selectionIndicator")
      static let text = Color.app.Text.hightlighed
    }

    enum Control {
      enum Background {
        static let primary = Color("mainControlBackground")
        static let secondary = Color("secondaryControlBackground")
      }

      enum Tint {
        static let primary = Color("mainControlTint")
        static let secondary = Color("secondaryControlTint")
      }
    }

    enum Text {
      static let primary = Color("mainText")
      static let hightlighed = Color("selectedText")
    }

    enum Image {
      static let primary = Color("primaryImageTint")
      static let secondary = Color("secondaryImageTint")
    }
  }
}
