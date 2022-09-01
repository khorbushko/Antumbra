//
//  SessionEnv+Create.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import Combine
import ComposableArchitecture

extension SessionEnvironment {

  static let live: Self = {
    .init(
      copyToClipboardAction: { data in
        Deferred {
          Future<Void, Never> { promise in
            data.copyToPastboard()
            promise(.success(()))
          }
        }
        .eraseToAnyPublisher()
      },
      pushExecuter: PushSender.sender.sendPushWith,
      onSave: SessionStore.store.save,
      certificateFetcher: KeychainCertificateExtractor.fetchAllAPNS,
      workQueue: .main
    )
  }()

  static let preview: Self = {
    .init(
      copyToClipboardAction: { data in
        Deferred {
          Future<Void, Never> { promise in
            data.copyToPastboard()
            promise(.success(()))
          }
        }
        .eraseToAnyPublisher()
      },
      pushExecuter: PushSender.sender.sendPushWith,
      onSave: SessionStore.store.save,
      certificateFetcher: KeychainCertificateExtractor.fetchAllAPNS,
      workQueue: .main
    )
  }()
}
