import XCTest
@testable import StringCryptor

final class AESTests: XCTestCase {
  
  func testAESInitInvalidKeyFail() {
    do {
      let _ = try AES(keyString: "drinkMoreCoffee")
    } catch {
      guard let aesError = error as? AES.Error else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      XCTAssertEqual(aesError, .invalidKeySize)
    }
  }
  
  func testAESInitValidKey() {
    do {
      let _ = try AES(keyString: "js@(Zmy&bf)u#kcMR?'#-6@r9JvC3#$J")
    } catch {
      XCTFail("Unexpected error: \(error)")
      return
    }
  }
  
  func testEncryptionEmptyStringFail() {
    let stringToEncrypt = ""
    do {
      let aes = try AES(keyString: "C_5};5fHV(v3M&h{m]6h_p[z[4h@ZWM$")
      let _ = try aes.encrypt(stringToEncrypt)
    } catch {
      guard let aesError = error as? AES.Error else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      XCTAssertEqual(aesError, .encryptionFailed)
    }
  }
  
  func testEncryptionAndDecryption() {
    let stringToEncrypt = "There is a lot of string to crypt"
    let key = "Nmts*z2?eD5g6}qaME8pE.x9EK$2Ev#]"
    
    do {
      let aesEncrypt = try AES(keyString: key)
      let encryptedData = try aesEncrypt.encrypt(stringToEncrypt)
      XCTAssertNotNil(encryptedData)
      
      let aesDecrypt = try AES(keyString: key)
      let decryptedString = try aesDecrypt.decrypt(encryptedData)
      XCTAssertEqual(decryptedString, stringToEncrypt)
      
    } catch {
      XCTFail("Unexpected error: \(error)")
      return
    }
  }
  
  func testDecryptEncryptedStringWithCorrectKey() {
    let correctString = "There is a lot of string to crypt"
    
    let encryptedString = "axQh00wO+pwSrFK1SegFcAbhfzLMRA8vi8mxh5NAy27tkm/bMo5M+xcrFaQr0BvET9wwVXo/7/dGZxB7ZCpGNw=="
    let key = "Nmts*z2?eD5g6}qaME8pE.x9EK$2Ev#]"
    
    do  {
      let data = try XCTUnwrap(Data(base64Encoded: encryptedString))
      let aesDecrypt = try AES(keyString: key)
      let decryptedString = try aesDecrypt.decrypt(data)
      
      XCTAssertEqual(decryptedString, correctString)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testDecryptEncryptedStringWithInCorrectKey() {
    let encryptedString = "axQh00wO+pwSrFK1SegFcAbhfzLMRA8vi8mxh5NAy27tkm/bMo5M+xcrFaQr0BvET9wwVXo/7/dGZxB7ZCpGNw=="
    let key = "Nmts*z2?eD5g6}qaME8pE.x9EK$44v#]"
    
    do  {
      let data = try XCTUnwrap(Data(base64Encoded: encryptedString))
      let aesDecrypt = try AES(keyString: key)
      _ = try aesDecrypt.decrypt(data)
      
      XCTFail("Unexpected no throw \(#function)")
    } catch {
      guard let aesError = error as? AES.Error else {
        XCTFail("Unexpected error type: \(error)")
        return
      }
      XCTAssertEqual(aesError, .dataToStringFailed)
    }
  }
  
  func testEncryptionAndDecryptionWithDifferentKeysFail() {
    let correctKey = "e6t!!y>C5q6p2t=Ae/m@hFjPhqEur_Gu"
    let incorrectKey = "CjbW}TaAsyPXd-J2fp)4WJ5>PJh_kG.#"
    let stringToEncrypt = "Printing description of decryptedString - Test Case '-[StringCryptorTests.AESTests testEncryptionAndDecryption]'"
    
    do {
      let aesCorrectKey = try AES(keyString: correctKey)
      let encryptedData = try aesCorrectKey.encrypt(stringToEncrypt)
      XCTAssertNotNil(encryptedData)
      
      let aesIncorrectKey = try AES(keyString: incorrectKey)
      let _ = try aesIncorrectKey.decrypt(encryptedData)
      
    } catch {
      guard let aesError = error as? AES.Error else {
        XCTFail("Unexpected error: \(error)")
        return
      }
      XCTAssertEqual(aesError, .dataToStringFailed)
    }
  }
}
