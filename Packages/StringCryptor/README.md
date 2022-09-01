# StringCryptor

Package that provide simple encryption mechanism for protecting various secrets used in the app, using `CommonCrypto` and `AES256`.

```
import Foundation
import StringCryptor

final class SpecificStringCryptor: StringCryptor {

private enum Key {
  static let inputKey = "CryptorKey"
}

init?() {
  if let cryptorKey = Bundle.main.infoDictionary?[Key.inputKey] as? String {
    try? super.init(cryptorKey)
  } else {
    Debug.failure("can't obtains cryptor config from .Plist")
    return nil
  }
}

// usage

var cryptor = SpecificStringCryptor()

try cryptor?.decryptString(encryptedString)
try cryptor?.enryptString(rawString)
```

`@propertyWrapper` can be used for simplified cases:

```
private struct Storage {
  private enum Constants {
    static let key: String = "FiugQTgPKkCWUY,VhfmM56KTtLVFvHFf"
    }

  @SerializedCryptedStored(
    key: "someKey",
    defaultValue: String.empty,
    cryptorKey: Constants.key
   )
   static var variableToProtect: String
}
```
