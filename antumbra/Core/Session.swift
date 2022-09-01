//
//  Session.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import Combine

@dynamicMemberLookup
final class Session: Identifiable, Equatable, Hashable, Codable {
  struct AuthProviderInfo: Equatable, Hashable, Codable {
    enum AuthType: String, Equatable, CaseIterable, Hashable, Codable {
      case p8
      case p12
      case keychain

      var fileExtension: String {
        switch self {
          case .p8:
            return "p8"
          case .p12:
            return "p12"
          case .keychain:
            return .empty
        }
      }
    }

    struct P8Identity: Equatable, Hashable, Codable {
      var fileContent: String?
      var fileData: Data?
      var fileName: String?

      var teamId: String?
      var keyId: String?

      var isComplete: Bool {
        return fileContent?.isEmpty == false
        && fileName?.isEmpty == false
        && teamId?.isEmpty == false
        && keyId?.isEmpty == false
        && fileData?.isEmpty == false
      }
    }

    struct P12Identity: Equatable, Hashable, Codable {
      var fileData: Data?
      var fileName: String?

      var passphrase: String?

      var isComplete: Bool {
        return passphrase?.isEmpty == false
        && fileName?.isEmpty == false
        && fileData?.isEmpty == false
      }
    }

    @CodableIgnored
    private(set) var cert: KeychainCertificate?
    private(set) var p8Identity: P8Identity = .init()
    private(set) var p12Identity: P12Identity = .init()
    private(set) var type: Session.AuthProviderInfo.AuthType = .p8

    var isAuthDataSetComplete: Bool {
      switch self.type {
        case .p8:
          return p8Identity.isComplete

        case .p12:
          return p12Identity.isComplete

        case .keychain:
          return cert != nil
      }
    }

    mutating func switchType(_ type: AuthType) {
      self.type = type
    }

    mutating func updateFile(_ fileULR: URL?, for type: AuthType) {
      if let fileULR = fileULR,
         fileULR.lastPathComponent.contains(type.fileExtension) {
        self.type = type

        switch type {
          case .p8:
            p8Identity.fileData = try? Data(contentsOf: fileULR)
            p8Identity.fileName = fileULR.lastPathComponent
            p8Identity.fileContent = fileULR.readFile()

          case .p12:
            p12Identity.fileData = try? Data(contentsOf: fileULR)
            p12Identity.fileName = fileULR.lastPathComponent

          case .keychain:
            fatalError("non-acceptable, use updateCert() for .keychain type")
        }
      }
    }

    mutating func updateCert(_ cert: KeychainCertificate) {
      self.cert = cert
    }

    mutating func updateTeamId(_ teamId: String?) {
      switch type {
        case .p8:
          p8Identity.teamId = teamId
        case .p12:
          break
        case .keychain:
          break
      }
    }

    mutating func updateKeyId(_ keyId: String?) {
      switch type {
        case .p8:
          p8Identity.keyId = keyId
        case .p12:
          break
        case .keychain:
          break
      }
    }

    mutating func updatePassphrase(_ passphrase: String?) {
      switch type {
        case .p8:
          break
        case .p12:
          p12Identity.passphrase = passphrase
        case .keychain:
          break
      }
    }
  }

  struct UIState: Equatable, Hashable, Codable {
    private var expandingState: [SessionState.Sections: Bool] = [
      .auth: true,
      .destination: true,
      .header: true,
      .body: true,
      .environment: true
    ]

    subscript (_ state: SessionState.Sections) -> Bool {
      get {
        expandingState[state] == true
      }

      set {
        expandingState[state] = newValue
      }
    }
  }

  struct PushData: Equatable, Hashable, Codable {
    enum PushPriority: Int, Equatable, Hashable, CaseIterable, Codable {
      case low = 1
      case normal = 5
      case critical = 10
    }

    enum PushType: String, Equatable, Hashable, CaseIterable, Codable {
      case alert
      case background
      case location
      case voip
      case complication
      case fileprovider
      case mdm

      var limitInBytes: Int {
        switch self {
          case .voip:
            return 5120
          default:
            return 4096
        }
      }
    }

    enum PushEnvironment: Codable, Equatable, Hashable, CaseIterable {
      case sandbox
      case production
    }

    var info: AuthProviderInfo = .init()
    var environment: PushEnvironment = .sandbox

    var bundleId: String?
    var apnsToken: String?

    var notificationId: String?
    var expiration: String?
    var collapseId: String?

    var kind: Session.PushData.PushType = .alert
    var priority: Session.PushData.PushPriority = .normal

    var pushMessage: String = PushPredefinedType.simple.content

    var payloadSizeInBytes: Int {
      pushMessage.utf8.count
    }

    var isPayloadExceedLimitInSize: Bool {
      payloadSizeInBytes > kind.limitInBytes
    }

    var canSendPush: Bool {
      info.isAuthDataSetComplete
        && apnsToken?.isEmpty == false
        && bundleId?.isEmpty == false
    }
  }

  subscript<T>(dynamicMember keyPath: WritableKeyPath<UIState, T>) -> T {
    uiState[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: WritableKeyPath<PushData, T>) -> T {
    pushData[keyPath: keyPath]
  }

  var id: UUID = .init()
  var name: String

  var pushData: PushData = .init()
  var uiState: UIState = .init()
  private(set) var pushResponses: [PushResponse] = []

  // MARK: - Lifecycle

  init(
    name: String
  ) {
    self.name = name
  }

  func addResponse(
    _ response: PushResponse
  ) {
    pushResponses.append(response)
  }


  func deleteResponse(
    _ response: PushResponse
  ) {
    pushResponses.removeAll(where: { $0.id == response.id })
  }

  // MARK: - Equtable

  static func == (lhs: Session, rhs: Session) -> Bool {
    /* workaround to make tca always update UI on any change of ref value */
    false
  }

  // MARK: - Hashable

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(pushData)
    hasher.combine(uiState)
  }
}

extension Session {
  static func named(
    _ name: String = Localizator.Session.defaultName
  ) -> Session {
    .init(name: name)
  }
}

extension Session {
  var icon: Icon {
    Icon.Root.session
  }
}
