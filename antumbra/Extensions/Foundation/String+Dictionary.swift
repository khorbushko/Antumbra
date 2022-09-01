//
//  String+Dictionary.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

extension String {
  enum Failure: Error {
    case cantConvertToData
  }

  func toDictionary() throws -> [String:AnyObject] {
    if let data = self.data(using: .utf8) {
      if let json = try? JSONSerialization.jsonObject(
        with: data,
        options: .mutableContainers
      ) as? [String:AnyObject] {
        return json
      } else {
        throw Failure.cantConvertToData
      }
    } else {
      throw Failure.cantConvertToData
    }
  }
}
