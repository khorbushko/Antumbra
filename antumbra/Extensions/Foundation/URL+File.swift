//
//  URL+File.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation

extension URL {
  func readFile() -> String? {
    try? String(contentsOfFile: self.path)
  }
}
