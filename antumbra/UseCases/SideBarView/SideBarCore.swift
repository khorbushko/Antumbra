//
//  SideBarCore.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import Combine
import ComposableArchitecture

struct SideBarState: Equatable {

  var sessions: [Session] = []
  var selectedSessionID: UUID?

  @Box var sessionState: SessionState?
}

enum SideBarAction {

  case onAppear

  case onPopAction

  case onReceiveSession([Session])

  case onSessionSelect(UUID)
  case sessionAction(SessionAction)

  case onNewSessionCreate
  case onRemoveSession
}

struct SideBarEnvironment {

  let workQueue: AnySchedulerOf<DispatchQueue>
  let sessionEnvironments: SessionEnvironment
  let sessionFetcher: () -> AnyPublisher<[Session], Never>
  let selectedSessionFetcher: () -> AnyPublisher<UUID, Never>
  let selectedSessionUpdater: (UUID) -> AnyPublisher<Void, Never>
  let addNewSession: () -> AnyPublisher<[Session], Never>
  let removeSession: (UUID) -> AnyPublisher<[Session], Never>

  init(
    workQueue: AnySchedulerOf<DispatchQueue>,
    sessionEnvironments: SessionEnvironment,
    sessionFetcher: @escaping () -> AnyPublisher<[Session], Never>,
    selectedSessionFetcher: @escaping () -> AnyPublisher<UUID, Never>,
    selectedSessionUpdater: @escaping (UUID) -> AnyPublisher<Void, Never>,
    addNewSession: @escaping () -> AnyPublisher<[Session], Never>,
    removeSession: @escaping (UUID) -> AnyPublisher<[Session], Never>
  ) {
    self.workQueue = workQueue
    self.sessionEnvironments = sessionEnvironments
    self.sessionFetcher = sessionFetcher
    self.selectedSessionFetcher = selectedSessionFetcher
    self.selectedSessionUpdater = selectedSessionUpdater
    self.addNewSession = addNewSession
    self.removeSession = removeSession
  }
}

enum SideBarReducer {
  static let defaultReducer = Reducer<
    SideBarState,
    SideBarAction,
    SideBarEnvironment
  > .combine(
    SessionReducer.defaultReducer
      .optional()
      .pullback(
        state: \SideBarState.sessionState,
        action: .sideBarToSession,
        environment: \.sessionEnvironments
      ),
    .init({ state, action, env in
      switch action {

        case .onAppear:
          return .concatenate(
            env.sessionFetcher()
              .receive(on: env.workQueue)
              .catchToEffect()
              .map({ result -> [Session] in
                switch result {
                  case .success(let sessions):
                    return sessions
                  case .failure:
                    return [Session]()
                }
              })
              .map(SideBarAction.onReceiveSession),
            env.selectedSessionFetcher()
              .receive(on: env.workQueue)
              .catchToEffect()
              .map({ result -> UUID in
                switch result {
                  case .success(let sessionUUID):
                    return sessionUUID
                }
              })
              .map(SideBarAction.onSessionSelect)
          )

        case .onReceiveSession(let sessions):
          state.sessions = sessions

        case .onSessionSelect(let selection):
            state.selectedSessionID = selection
          if let selectedSession = state.sessions
            .first(where: { $0.id == selection }) {
            state.sessionState = .init(session: selectedSession)
          }

          return env.selectedSessionUpdater(selection)
            .eraseToEffect()
            .fireAndForget()

        case .onNewSessionCreate:
          return env.addNewSession()
            .receive(on: env.workQueue)
            .catchToEffect()
            .map({ result -> [Session] in
              switch result {
                case .success(let sessions):
                  return sessions
                case .failure:
                  return [Session]()
              }
            })
            .map(SideBarAction.onReceiveSession)

        case .onRemoveSession:
          if let sessionIdToRemove = state.selectedSessionID,
             let newSelection = state.sessions
            .filter({ $0.id != sessionIdToRemove }).first?.id {
            
            return .concatenate(
              env.removeSession(sessionIdToRemove)
                .receive(on: env.workQueue)
                .catchToEffect()
                .map({ result -> [Session] in
                  switch result {
                    case .success(let sessions):
                      return sessions
                    case .failure:
                      return [Session]()
                  }
                })
                .map(SideBarAction.onReceiveSession),
              Effect(value: .onSessionSelect(newSelection))
            )
          }

        case .onPopAction:
          break
        case .sessionAction:
              break
      }
       return .none
    })
  )
}

fileprivate extension CasePath {

  // MARK: - CasePath+Root

  static var sideBarToSession: CasePath<SideBarAction, SessionAction> {
    .init(
      embed: SideBarAction.sessionAction,
      extract: { result in
        guard case let .sessionAction(action) = result else {
          return nil
        }
        return action
      }
    )
    }
}
