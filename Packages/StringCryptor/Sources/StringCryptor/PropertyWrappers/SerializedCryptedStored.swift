//
//  SerializedCryptedStored.swift
//  
//
//  Created by Kyryl Horbushko on 09.04.2020.
//

import Foundation

@propertyWrapper
public struct SerializedCryptedStored<T: Codable> {
  
  private let key: String
  private let defaultValue: T
  private var cryptor: StringCryptor?
  
  // MARK: - LifeCycle
  
  public init(key: String, defaultValue: T, cryptorKey: String) {
    self.key = key
    self.defaultValue = defaultValue
    
    cryptor = try? StringCryptor(cryptorKey)
  }
  
  public var wrappedValue: T {
    get {
      let decoder = JSONDecoder()
      
      if let objectSting = UserDefaults.standard.string(forKey: key),
         let decryptedString = try? cryptor?.decryptString(objectSting),
         let data = decryptedString.data(using: .utf8),
         let object = try? decoder.decode(T.self, from: data) {
        return object
      }
      
      return defaultValue
    }
    set {
      let encoder = JSONEncoder()
      
      if let objectData = try? encoder.encode(newValue),
         let stringFromData = String(bytes: objectData, encoding: .utf8),
         let encryptedString = try? cryptor?.encryptString(stringFromData) {
        UserDefaults.standard.set(encryptedString, forKey: key)
      } else {
        UserDefaults.standard.removeObject(forKey: key)
      }
    }
  }
}
