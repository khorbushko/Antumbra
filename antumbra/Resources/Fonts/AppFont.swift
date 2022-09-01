//
//  AppFont.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation

extension FontFamily: AppFont {
  static let roboto = FontFamily(
    bold: FontName.appBold,
    regular: FontName.appRegular,
    italic: FontName.appItalic
  )

  public static var app: FontFamily {
    .roboto
  }
}

public extension FontName {
  static let appBold = "Roboto-Bold"
  static let appRegular = "Roboto-Regular"
  static let appItalic = "Roboto-Italic"
}
