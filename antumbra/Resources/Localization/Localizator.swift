//
//  Localizator.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation

enum Localizator {
  enum Main {
    static let appTitle = Localizator.localizedValue("app.title")

    enum Hints {
      enum Toolbar {
        static let hideSideBar = Localizator.localizedValue("app.toolbar.toogle.hint")
      }
    }
  }

  static func localizedValue(
    _ key: String,
    tableName: String = "Localizable",
    bundle: Bundle = .main
  ) -> String {
    NSLocalizedString(
      key,
      tableName: tableName,
      bundle: bundle,
      value: .empty,
      comment: .empty
    )
  }
}
