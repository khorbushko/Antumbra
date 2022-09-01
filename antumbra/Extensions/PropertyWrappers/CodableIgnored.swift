//
//  CodableIgnored.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 31.08.2022.
//

import Foundation

@propertyWrapper
public struct CodableIgnored<T>: Codable {
  public var wrappedValue: T?

  public init(wrappedValue: T?) {
    self.wrappedValue = wrappedValue
  }

  public init(from decoder: Decoder) throws {
    self.wrappedValue = nil
  }

  public func encode(to encoder: Encoder) throws {
    // Do nothing
  }
}

extension KeyedDecodingContainer {
  public func decode<T>(
    _ type: CodableIgnored<T>.Type,
    forKey key: Self.Key) throws -> CodableIgnored<T> {
      CodableIgnored(wrappedValue: nil)
    }
}

extension KeyedEncodingContainer {
  public mutating func encode<T>(
    _ value: CodableIgnored<T>,
    forKey key: KeyedEncodingContainer<K>.Key) throws {
      // Do nothing
    }
}

extension CodableIgnored: Hashable {
  public func hash(into hasher: inout Hasher) {
    // Do nothing
  }
}

extension CodableIgnored: Equatable {
  public static func == (lhs: CodableIgnored<T>, rhs: CodableIgnored<T>) -> Bool {
    false
  }
}
