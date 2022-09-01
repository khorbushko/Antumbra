//
//  PopoverInfo.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 21.08.2022.
//

import Foundation

enum PopoverInfo: Equatable {
  case none

  case teamId
  case keyId
  case bundleId

  case passphrase

  case environment

  case destination

  case notificationId
  case expiration
  case collapseId
  case priority
  case kind

  case payload

  var isMandatory: Bool {
    switch self {
      case .teamId,
          .keyId,
          .bundleId,
          .destination,
          .environment,
          .payload,
          .passphrase:
        return true

      default:
        return false
    }
  }

  var imageName: String? {
    switch self {
      case .teamId:
        return "ic_popover_teamID"
      case .keyId:
        return "ic_popover_keyID"
      case .bundleId:
        return "ic_popover_bundleID"

      case .notificationId,
          .expiration,
          .priority,
          .collapseId,
          .kind,
          .destination,
          .environment,
          .payload,
          .passphrase:
        return nil

      case .none:
        return nil
    }
  }

  var placeholder: String {
    switch self {
      case .teamId:
        return Localizator.Popover.Placeholder.teamId
      case .keyId:
        return Localizator.Popover.Placeholder.keyId
      case .passphrase:
        return Localizator.Popover.Placeholder.passphrase

      case .bundleId:
        return Localizator.Popover.Placeholder.bundleId
      case .destination:
        return Localizator.Popover.Placeholder.destination

      case .notificationId:
        return Localizator.Popover.Placeholder.notificationId
      case .expiration:
        return Localizator.Popover.Placeholder.expiration
      case .collapseId:
        return Localizator.Popover.Placeholder.collapseId

      case .none,
          .priority,
          .kind,
          .environment,
          .payload:
        return .empty
    }
  }

  var title: String {
    switch self {
      case .teamId:
        return Localizator.Popover.Title.teamId
      case .keyId:
        return Localizator.Popover.Title.keyId

      case .passphrase:
        return Localizator.Popover.Title.passphrase

      case .bundleId:
        return Localizator.Popover.Title.bundleId
      case .destination:
        return Localizator.Popover.Title.destination

      case .environment:
        return Localizator.Popover.Title.environment

      case .notificationId:
        return Localizator.Popover.Title.notificationId
      case .expiration:
        return Localizator.Popover.Title.expiration
      case .priority:
        return Localizator.Popover.Title.priority
      case .collapseId:
        return Localizator.Popover.Title.collapseId
      case .kind:
        return Localizator.Popover.Title.kind
      case .payload:
        return Localizator.Popover.Title.payload

      case .none:
        return .empty
    }
  }

  var description: String {
    switch self {
      case .teamId:
        return Localizator.Popover.Description.teamId
      case .keyId:
        return Localizator.Popover.Description.keyId
      case .passphrase:
        return Localizator.Popover.Description.passphrase

      case .bundleId:
        return Localizator.Popover.Description.bundleId
      case .destination:
        return Localizator.Popover.Description.destination
      case .environment:
        return Localizator.Popover.Description.environment
      case .notificationId:
        return Localizator.Popover.Description.notificationId
      case .expiration:
        return Localizator.Popover.Description.expiration
      case .priority:
        return Localizator.Popover.Description.priority
      case .collapseId:
        return Localizator.Popover.Description.collapseId
      case .kind:
        return Localizator.Popover.Description.kind
      case .payload:
        return Localizator.Popover.Description.payload

      default:
        return .empty
    }
  }

  var link: String? {
    switch self {
      case .teamId:
        return "https://developer.apple.com/account/#!/membership"
      case .keyId:
        return "https://developer.apple.com/account/resources/authkeys"
      case .bundleId:
        return "https://appstoreconnect.apple.com/apps"

      case .payload:
        return "https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1"

      default:
        return nil
    }
  }
}
