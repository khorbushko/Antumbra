//
//  Box.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation

private final class Ref<T: Equatable>: Equatable {
  var val: T

  init(_ v: T) {
    self.val = v
  }

  static func == (lhs: Ref<T>, rhs: Ref<T>) -> Bool {
    lhs.val == rhs.val
  }
}

@propertyWrapper
public struct Box<T: Equatable>: Equatable {
  private var ref: Ref<T>

  public init(wrappedValue: T) {
    self.ref = Ref(wrappedValue)
  }

  public var wrappedValue: T {
    get { ref.val }
    set {
      if !isKnownUniquelyReferenced(&ref) {
        ref = Ref(newValue)
        return
      }
      ref.val = newValue
    }
  }

  public var projectedValue: Box<T> {
    self
  }
}

extension Box: Hashable where T: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(wrappedValue)
  }
}
