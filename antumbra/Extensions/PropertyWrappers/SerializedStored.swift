//
//  SerializedStored.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

@propertyWrapper
struct SerializedStored<T: Codable> {

  private let key: String
  private let defaultValue: T
  private let suite: UserDefaults

  // MARK: - LifeCycle

  init(
    _ key: String,
    defaultValue: T,
    suite: UserDefaults = .standard
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.suite = suite
  }

  var wrappedValue: T {
    get {
      let decoder = JSONDecoder()

      if let storedData = suite.object(forKey: key) as? Data,
         let object = try? decoder.decode(T.self, from: storedData) {
        return object
      }

      return defaultValue
    }
    set {
      let encoder = JSONEncoder()

      if let objectData = try? encoder.encode(newValue) {
        suite.set(objectData, forKey: key)
      } else {
        suite.removeObject(forKey: key)
      }
    }
  }
}
