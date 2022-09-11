//
//  String+Sanitize.swift
//  antumbra
//
//  Created by Kyrylo Horbushko on 11.09.2022.
//

import Foundation

extension String {

  var nilIfEmpty: String? {
    self.isEmpty ? nil : self
  }
}
