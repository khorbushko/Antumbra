//
//  Icon+Session.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI

extension Icon {
  enum Session {

  }
}

extension Image {
  enum Session {
    enum Toolbar {
      static let hidePannel: Image = Image(systemName: "sidebar.left")
    }

    enum General {
      static let copy = Image(systemName: "doc.on.doc")
      static let info = Image(systemName: "info.circle")
    }

    enum History {
      static let remove = Image(systemName: "trash.circle")
    }
  }
}
