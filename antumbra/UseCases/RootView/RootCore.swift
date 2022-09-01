//
//  RootCore.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import Combine

import ComposableArchitecture

struct RootState: Equatable {
  @Box var sideBarState: SideBarState = .init()
}

enum RootAction {
  case onToogleSidePanel

  case sideBarAction(SideBarAction)
}

struct RootEnvironment {

  let workQueue: AnySchedulerOf<DispatchQueue>
  let sideBarEnvironment: SideBarEnvironment
  let toogleToolbarAction: () -> AnyPublisher<Void, Never>

  init(
    workQueue: AnySchedulerOf<DispatchQueue>,
    sideBarEnvironment: SideBarEnvironment,
    toogleToolbarAction: @escaping () -> AnyPublisher<Void, Never>
  ) {
    self.workQueue = workQueue
    self.sideBarEnvironment = sideBarEnvironment
    self.toogleToolbarAction = toogleToolbarAction
  }
}

enum RootReducer {
  static let defaultReducer = Reducer<
    RootState,
    RootAction,
    RootEnvironment
  > .combine(
    SideBarReducer.defaultReducer
      .pullback(
        state: \RootState.sideBarState,
        action: .rootToSideBar,
        environment: \.sideBarEnvironment
      ),
    .init({ state, action, env in
      switch action {
        case .onToogleSidePanel:
          return env.toogleToolbarAction()
            .eraseToEffect()
            .fireAndForget()

        case .sideBarAction:
          break
      }
        return .none
    })
  )
}

fileprivate extension CasePath {

  // MARK: - CasePath+Root

  static var rootToSideBar: CasePath<RootAction, SideBarAction> {
    .init(
      embed: RootAction.sideBarAction,
      extract: { result in
        guard case let .sideBarAction(action) = result else {
          return nil
        }
        return action
      }
    )
  }
}
