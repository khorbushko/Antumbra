//
//  Dictionary+Merge.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

extension Dictionary {
  static func +=(lhs: inout Self, rhs: Self) {
    lhs.merge(rhs) { _ , new in new }
  }
  static func +=<S: Sequence>(lhs: inout Self, rhs: S) where S.Element == (Key, Value) {
    lhs.merge(rhs) { _ , new in new }
  }
}
