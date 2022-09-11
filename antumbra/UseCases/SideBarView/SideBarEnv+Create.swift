//
//  SessionEnv+Create.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import Combine
import ComposableArchitecture

extension SideBarEnvironment {

  static let live: Self = {
    .init(
      workQueue: .main,
      sessionEnvironments: .live,
      sessionFetcher: SessionStore.store.fetchAllSession,
      selectedSessionFetcher: SessionStore.store.fetchSelectedSessionID,
      selectedSessionUpdater: SessionStore.store.updateSelectedSession(_:),
      addNewSession: SessionStore.store.addNewSession,
      removeSession: SessionStore.store.removeSession,
      copySession: SessionStore.store.copySession
    )
  }()

  static let preview: Self = {
    let session = Session(name: "1")
    return .init(
      workQueue: .main,
      sessionEnvironments: .preview,
      sessionFetcher: {
        Deferred {
          Future { promise in
            promise(.success([session]))
          }
        }
        .eraseToAnyPublisher()
      },
      selectedSessionFetcher: {
        Deferred {
          Future { promise in
            promise(.success(session.id))
          }
        }
        .eraseToAnyPublisher()
      },
      selectedSessionUpdater: SessionStore.store.updateSelectedSession(_:),
      addNewSession: SessionStore.store.addNewSession,
      removeSession: SessionStore.store.removeSession,
      copySession: SessionStore.store.copySession
    )
  }()
}
