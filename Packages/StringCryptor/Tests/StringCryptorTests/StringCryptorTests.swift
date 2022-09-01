//
//  File.swift
//
//
//  Created by Kyryl Horbushko on 31.12.2019.
//

import Foundation
import XCTest
@testable import StringCryptor

final class StringCryptorTest: XCTestCase {
  
  func testInitializationAESInitInvalidKeyFail() {
    do {
      let _ = try StringCryptor("incorectKey")
    } catch {
      guard let aesError = error as? AES.Error else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      XCTAssertEqual(aesError, .invalidKeySize)
    }
  }
  
  func testInitializationAESInitWithValidKey() {
    do {
      let encryptor = try StringCryptor("FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFe")
      XCTAssertNotNil(encryptor)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testEncryptionDecryptionAESInitWithValidKey() {
    do {
      let encryptor = try StringCryptor("FiugQTgPNwCWUY,VhfmM4cKXTLVFvHFe")
      XCTAssertNotNil(encryptor)
      
      let stringToCheck = "ababaglamaga"
      let encrypted = try encryptor.encryptString(stringToCheck)
      let decrypted = try encryptor.decryptString(encrypted)
      
      XCTAssertEqual(decrypted, stringToCheck)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
