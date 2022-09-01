//
//  Dictionary+Data.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

extension Dictionary {

  func toData() throws -> Data {
    try JSONSerialization.data(
      withJSONObject: self as Any,
      options: []
    )
  }
}
