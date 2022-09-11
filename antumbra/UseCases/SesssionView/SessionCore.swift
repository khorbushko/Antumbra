//
//  SessionCore.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import Combine

import ComposableArchitecture
import SwiftUI

struct SessionState: Equatable {
  enum ChangeKind: Equatable {
    case sessionName(String)
    case teamId(String)
    case bundleId(String)
    case keyId(String)
    case notificationId(String)
    case expiration(Int)
    case collapseId(String)
    case pushType(Session.PushData.PushType)
    case apnsToken(String)
    case pushEnvironment(Session.PushData.PushEnvironment)
    case priority(Session.PushData.PushPriority)
    case payload(String)
    case payloadType(PushPredefinedType)
    case onSelectKeychainCert(KeychainCertificate)

    case passphrase(String)

    case p8URL(URL?)
    case p12URL(URL?)
    case p12NoPassword(Bool)
  }

  enum Sections: Codable {
    case auth
    case destination
    case header
    case body
    case environment
  }

  enum AnimationKind: Equatable {
    case copyAuthInfo
  }

  enum HistoryViewAction: Equatable {
    case delete(PushResponse)
  }

  var session: Session

  // MARK: - UI
  let historyViewVisibilityThreshould: CGFloat = 200

  var isAuthSectionExpanded: Bool {
    session[.auth]
  }

  var isDestinationSectionExpanded: Bool {
    session[.destination]
  }

  var isHeaderSectionExpanded: Bool {
    session[.header]
  }

  var isBodySectionExpanded: Bool {
    session[.body]
  }

  var isEnvironmentSectionExpanded: Bool {
    session[.environment]
  }

  // MARK: - Details

  // MARK: - p12

  var passphrase: String {
    session.pushData.info.p12Identity.passphrase ?? .empty
  }

  var skipPassphrase: Bool = false

  // MARK: - p8

  var teamId: String {
    session.pushData.info.p8Identity.teamId ?? .empty
  }

  var keyId: String {
    session.pushData.info.p8Identity.keyId ?? .empty
  }

  // MARK: - Keychain

  var certificates: [KeychainCertificate] = []
  var selectedCertificate: KeychainCertificate? {
    session.pushData.info.cert
  }

  // MARK: - Shared

  var bundleId: String {
    session.bundleId ?? .empty
  }

  var apnsToken: String {
    session.apnsToken ?? .empty
  }

  var notificationId: String {
    session.notificationId ?? .empty
  }

  var expiration: String {
    session.expiration ?? .empty
  }

  let supportedPushPriority: [Session.PushData.PushPriority] = Session.PushData.PushPriority.allCases
  var pushPriority: Session.PushData.PushPriority {
    session.priority
  }

  let supportedPushType: [Session.PushData.PushType] = Session.PushData.PushType.allCases
  var pushType: Session.PushData.PushType {
    session.kind
  }

  var collapseId: String {
    session.collapseId ?? .empty
  }

  let supportedPushEnv: [Session.PushData.PushEnvironment] = Session.PushData.PushEnvironment.allCases
  var pushEnvironment: Session.PushData.PushEnvironment {
    session.environment
  }

  var canSendRequest: Bool {
    session.pushData.canSendPush
  }

  let pushPayloads: [PushPredefinedType] = PushPredefinedType.allCases
  var selectedPushPayload: PushPredefinedType = .simple
  var pushPayload: String {
    session.pushMessage
  }
  var formattedPayloadSize: String {
    let formatter = ByteCountFormatter()
    formatter.countStyle = .memory
    formatter.allowedUnits = .useBytes

    let result = formatter.string(
      from: .init(
        value: Double(session.pushData.payloadSizeInBytes),
        unit: .bytes
      )
    )
    return result
  }

  var isPayloadExceedLimit: Bool {
    session.pushData.isPayloadExceedLimitInSize
  }

  let authTypes: [Session.AuthProviderInfo.AuthType] = [.p8, .p12, .keychain]
  var selectedAuthType: Session.AuthProviderInfo.AuthType {
    session.info.type
  }
  var authSlideTransitionFromLeft: Bool = false

  var playCopyAnimation: Bool = false
  var popoverType: PopoverInfo = .none

  var isLoading: Bool = false

  var failMessage: String?
  var showFail: Bool = false

  // MARK: - History

  var historyItems: [PushResponse] {
    session.pushResponses
  }

  // MARK: - Lifecycle

  init(session: Session) {
    self.session = session
  }
}

enum SessionAction {
  case onCopyAuthAction(Session.AuthProviderInfo.AuthType)
  case onChange(SessionState.ChangeKind)
  case onToogleExpandStateFor(SessionState.Sections)
  case onChangeAuthType(Session.AuthProviderInfo.AuthType)

  case onEndAnimation(SessionState.AnimationKind)
  case onShowPopover(PopoverInfo)
  case onHidePopover

  case onExecute
  case onExecuteSuccess(PushResponse)
  case onExecuteFail(Error)

  case onHistoryViewAction(SessionState.HistoryViewAction)

  case onCopyValue(String)

  case onShowFail(Error)
  case onHideFail

  case onFetchKeychainCerts
  case onReceiveKeychainCets([KeychainCertificate])
}

struct SessionEnvironment {
  let workQueue: AnySchedulerOf<DispatchQueue>
  let copyToClipboardAction: (String) -> AnyPublisher<Void, Never>
  let pushExecuter: (Session) -> AnyPublisher<PushResponse, Error>
  let onSave: () -> AnyPublisher<Void, Never>
  let certificateFetcher: () -> AnyPublisher<[KeychainCertificate], Never>

  init(
    copyToClipboardAction: @escaping (String) -> AnyPublisher<Void, Never>,
    pushExecuter: @escaping (Session) -> AnyPublisher<PushResponse, Error>,
    onSave: @escaping () -> AnyPublisher<Void, Never>,
    certificateFetcher: @escaping () -> AnyPublisher<[KeychainCertificate], Never>,
    workQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.copyToClipboardAction = copyToClipboardAction
    self.pushExecuter = pushExecuter
    self.onSave = onSave
    self.certificateFetcher = certificateFetcher
    self.workQueue = workQueue
  }
}

enum SessionReducer {
  static let defaultReducer = Reducer<
    SessionState,
    SessionAction,
    SessionEnvironment
  > .combine(
    .init({ state, action, env in
      switch action {
        case .onChange(let changeType):
          switch changeType {
            case .sessionName(let name):
              state.session.name = name
            case .teamId(let teamID):
              state.session.pushData.info.updateTeamId(teamID.nilIfEmpty)
            case .bundleId(let bundleID):
              state.session.pushData.bundleId = bundleID.nilIfEmpty
            case .keyId(let keyID):
              state.session.pushData.info.updateKeyId(keyID.nilIfEmpty)
            case .notificationId(let notificationID):
              state.session.pushData.notificationId = notificationID.nilIfEmpty
            case .expiration(let expiration):
              state.session.pushData.expiration = "\(expiration)"
            case .priority(let priority):
              state.session.pushData.priority = priority
            case .collapseId(let collapseId):
              state.session.pushData.collapseId = collapseId.nilIfEmpty
            case .pushType(let pushType):
              state.session.pushData.kind = pushType
            case .apnsToken(let apnsToken):
              state.session.pushData.apnsToken = apnsToken.nilIfEmpty
            case .pushEnvironment(let environment):
              state.session.pushData.environment = environment
              
            case .payload(let payload):
              state.session.pushData.pushMessage = payload
            case .payloadType(let payloadType):
              state.selectedPushPayload = payloadType
              state.session.pushData.pushMessage = payloadType.content

            case .p8URL(let url):
              state.session.pushData.info.updateFile(url, for: .p8)
            case .p12URL(let url):
              state.session.pushData.info.updateFile(url, for: .p12)

            case .passphrase(let password):
              if !state.skipPassphrase {
                state.session.pushData.info.updatePassphrase(password.nilIfEmpty)
              }
            case .p12NoPassword(let isNoPassword):
              state.skipPassphrase = isNoPassword
              if isNoPassword {
                state.session.pushData.info.updatePassphrase(nil)
              }

            case .onSelectKeychainCert(let cert):
              state.session.pushData.info.updateCert(cert)
          }

        case .onToogleExpandStateFor(let section):
          switch section {
            case .auth:
              state.session.uiState[.auth] = !state.isAuthSectionExpanded
            case .destination:
              state.session.uiState[.destination] = !state.isDestinationSectionExpanded
            case .header:
              state.session.uiState[.header] = !state.isHeaderSectionExpanded
            case .body:
              state.session.uiState[.body] = !state.isBodySectionExpanded
            case .environment:
              state.session.uiState[.environment] = !state.isEnvironmentSectionExpanded
          }

        case .onChangeAuthType(let authType):
            state.session.pushData.info.switchType(authType)

        case .onCopyAuthAction(let auth):
          switch auth {
            case .p8:
              if let dataToCopy = state.session.pushData.info.p8Identity.fileContent {
                state.playCopyAnimation = true
                return .concatenate(
                  env.copyToClipboardAction(dataToCopy)
                    .catchToEffect()
                    .fireAndForget(),
                  .init(value: .onEndAnimation(.copyAuthInfo))
                  .delay(for: 1.75, scheduler: env.workQueue)
                  .eraseToEffect()
                )
              }
            case .p12:
              break
            case .keychain:
              break
          }

        case .onEndAnimation(let kind):
          switch kind {
            case .copyAuthInfo:
              state.playCopyAnimation = false
          }

        case .onShowPopover(let popoverType):
          state.popoverType = popoverType
        case .onHidePopover:
          state.popoverType = .none

        case .onExecute:
          state.isLoading = true
          return env.pushExecuter(state.session)
            .delay(for: 0.25, scheduler: env.workQueue.animation())
            .receive(on: env.workQueue)
            .catchToEffect()
            .map { result in
              switch result {
                case .failure(let fail):
                  return SessionAction.onExecuteFail(fail)
                case .success(let value):
                  return SessionAction.onExecuteSuccess(value)
              }
            }

        case .onExecuteSuccess(let result):
          state.session.addResponse(result)
          state.isLoading = false

        case .onExecuteFail(let fail):
          state.isLoading = false

          return Effect(value: .onShowFail(fail))

        case .onShowFail(let fail):
          state.failMessage = (fail as NSError).description
          state.showFail = true
          return Effect(value: .onHideFail)
            .delay(for: 5, scheduler: env.workQueue)
            .eraseToEffect()

        case .onHideFail:
          state.showFail = false
          state.failMessage = nil

        case .onHistoryViewAction(let action):
          switch action {
            case .delete(let element):
              state.session.deleteResponse(element)
          }

        case .onCopyValue(let value):
          return env.copyToClipboardAction(value)
            .catchToEffect()
            .fireAndForget()

        case .onFetchKeychainCerts:
          return env.certificateFetcher()
            .receive(on: DispatchQueue.main)
            .map(SessionAction.onReceiveKeychainCets)
            .eraseToEffect()

        case .onReceiveKeychainCets(let certs):
          state.certificates = certs
          
      }
      return env.onSave()
        .catchToEffect()
        .fireAndForget()
    })
  )
}
