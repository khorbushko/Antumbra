//
//  PushStorage.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation
import Combine

import StringCryptor

protocol TokenStorage {

  func fetchTokens() -> AnyPublisher<[JWTToken], Never>
  func fetchTokensFor(teamID: String, keyID: String) -> AnyPublisher<JWTToken, Error>

  func addToken(_ token: JWTToken) -> AnyPublisher<JWTToken, Never>
  func removeToken(_ token: JWTToken) -> AnyPublisher<Void, Never>
}
