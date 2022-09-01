//
//  Data+PrettyPrinted.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation

extension Data {
  /// NSString gives us a nice sanitized debugDescription
  var prettyPrintedJSONString: String? {
    if let object = try? JSONSerialization.jsonObject(with: self, options: []),
       let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
       let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
      return prettyPrintedString as String
    }
    return nil
  }
}
