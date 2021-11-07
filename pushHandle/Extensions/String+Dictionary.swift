//
//  String+Dictionary.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation

extension String {
  enum Failure: Error {
    case cantConvertToData
  }

  func toDictionary() throws -> [String:AnyObject]? {
    if let data = self.data(using: .utf8) {
      let json = try JSONSerialization.jsonObject(
        with: data,
        options: .mutableContainers
      ) as? [String:AnyObject]
      return json
    } else {
      throw Failure.cantConvertToData
    }
  }
}
