//
//  SessionStore.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import StringCryptor

import Combine

final class SessionStore {
  static let store: SessionStore = .init()

  private enum Constants {
    static let key: String = "FiugQTgPKkCWUY,VhfmM56KTtLVFvHFf"
  }

  @SerializedCryptedStored(
    key: "sd.kh.store.accessToken",
    defaultValue: [],
    cryptorKey: Constants.key
  )
  private static var accessTokens: [JWTToken]

  @SerializedCryptedStored(
    key: "sd.kh.store.sessions",
    defaultValue: [],
    cryptorKey: Constants.key
  )
  private var storedSessions: [Session]

  private var sessions: [Session] = []
  private(set) lazy var selectedSessionID: UUID = {
    sessions[0].id
  }()

  private var tokens: Set<AnyCancellable> = []

  // MARK: - Lifecycle

  private init() {
    if storedSessions.isEmpty {
      storedSessions = [
        .named("\(Localizator.Session.defaultName) 0")
      ]
    }

    sessions = storedSessions
  }
}

extension SessionStore: SessionStorage {

  func save() -> AnyPublisher<Void, Never> {
    storedSessions = sessions

    return Just(())
      .eraseToAnyPublisher()
  }

  func fetchSelectedSessionID() -> AnyPublisher<UUID, Never> {
    Just(selectedSessionID)
      .eraseToAnyPublisher()
  }

  func fetchAllSession() -> AnyPublisher<[Session], Never> {
    Just(sessions)
      .eraseToAnyPublisher()
  }

  func updateSelectedSession(_ sessionUUID: UUID) -> AnyPublisher<Void, Never> {
    selectedSessionID = sessionUUID

    return Just(())
      .eraseToAnyPublisher()
  }

  func removeSession(_ sessionUUID: UUID) -> AnyPublisher<[Session], Never> {
    sessions.removeAll(where: { $0.id == sessionUUID })

    return Just(sessions)
      .eraseToAnyPublisher()
  }

  func addNewSession() -> AnyPublisher<[Session], Never> {
    sessions
      .append(.named("\(Localizator.Session.defaultName) \(sessions.count)"))

    return Just(sessions)
      .eraseToAnyPublisher()
  }
}

extension SessionStore: TokenStorage {
  enum Failure: Error {
    case noDataFound
  }

  // MARK: - TokenStorage

  func fetchTokens() -> AnyPublisher<[JWTToken], Never> {
    Deferred {
      Future { promise in
        promise(.success(SessionStore.accessTokens))
      }
    }
    .eraseToAnyPublisher()
  }

  func fetchTokensFor(
    teamID: String,
    keyID: String
  ) -> AnyPublisher<JWTToken, Error> {
    Deferred {
      Future { promise in
        if let token = SessionStore.accessTokens
          .first(where: { $0.thumbprint == keyID && $0.issuer == teamID }) {
          promise(.success(token))
        } else {
          promise(.failure(Failure.noDataFound))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  func addToken(_ token: JWTToken) -> AnyPublisher<JWTToken, Never> {
    removeToken(token)
      .flatMap { _ in
        Future { promise in
          SessionStore.accessTokens.append(token)
          promise(.success((token)))
        }
      }
      .eraseToAnyPublisher()
  }

  func removeToken(_ token: JWTToken) -> AnyPublisher<Void, Never> {
    Deferred {
      Future { promise in
        var tokens = SessionStore.accessTokens
        tokens.removeAll(
          where: {
            $0.raw == token.raw
            || ($0.thumbprint == token.thumbprint && $0.issuer == token.issuer)
          }
        )
        SessionStore.accessTokens = tokens
        promise(.success(()))
      }
    }
    .eraseToAnyPublisher()
  }
}
