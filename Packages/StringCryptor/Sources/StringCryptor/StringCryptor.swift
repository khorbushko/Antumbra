//
//  StringCryptor.swift
//
//
//  Created by Kyryl Horbushko
//

import Foundation

public class StringCryptor {

  private let aes: AES

  // MARK: - LifeCycle

  public init(_ key: String) throws {
    aes = try AES(keyString: key)
  }

  public func encryptString(_ stringToEncrypt: String) throws -> String {
    let encryptedData: Data = try aes.encrypt(stringToEncrypt)
    return encryptedData.base64EncodedString()
  }

  public func decryptString(_ stringToDecrypt: String) throws -> String {
    if let encryptedData = Data(base64Encoded: stringToDecrypt, options: []) {
      let valueToReturn: String = try aes.decrypt(encryptedData)
      return valueToReturn
    }

    throw AES.Error.decryptionFailed
  }
}
