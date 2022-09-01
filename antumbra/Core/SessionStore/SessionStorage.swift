//
//  SessionStorage.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation
import Combine

protocol SessionStorage {

  func fetchAllSession() -> AnyPublisher<[Session], Never>
  func fetchSelectedSessionID() -> AnyPublisher<UUID, Never>

  func updateSelectedSession(_ sessionUUID: UUID) -> AnyPublisher<Void, Never>
  func removeSession(_ sessionUUID: UUID) -> AnyPublisher<[Session], Never>
  func addNewSession() -> AnyPublisher<[Session], Never>

  func save() -> AnyPublisher<Void, Never>
}
