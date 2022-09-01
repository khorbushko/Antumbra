//
//  Localizator+Popover.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 26.08.2022.
//

import Foundation

extension Localizator {

  enum Popover {
    enum Placeholder {
      static let teamId = Localizator.localizedPopoverValue("popover.placeholder.teamId")
      static let keyId = Localizator.localizedPopoverValue("popover.placeholder.keyId")
      static let bundleId = Localizator.localizedPopoverValue("popover.placeholder.bundleId")
      static let destination = Localizator.localizedPopoverValue("popover.placeholder.destination")
      static let notificationId = Localizator.localizedPopoverValue("popover.placeholder.notificationId")
      static let expiration = Localizator.localizedPopoverValue("popover.placeholder.expiration")
      static let collapseId = Localizator.localizedPopoverValue("popover.placeholder.collapseId")
      static let passphrase = Localizator.localizedPopoverValue("popover.placeholder.passphrase")
    }

    enum Title {
      static let teamId = Localizator.localizedPopoverValue("popover.title.teamId")
      static let keyId = Localizator.localizedPopoverValue("popover.title.keyId")
      static let bundleId = Localizator.localizedPopoverValue("popover.title.bundleId")
      static let destination = Localizator.localizedPopoverValue("popover.title.destination")
      static let environment = Localizator.localizedPopoverValue("popover.title.environment")
      static let notificationId = Localizator.localizedPopoverValue("popover.title.notificationId")
      static let expiration = Localizator.localizedPopoverValue("popover.title.expiration")
      static let collapseId = Localizator.localizedPopoverValue("popover.title.collapseId")
      static let kind = Localizator.localizedPopoverValue("popover.title.kind")
      static let priority = Localizator.localizedPopoverValue("popover.title.priority")
      static let payload = Localizator.localizedPopoverValue("popover.title.payload")
      static let passphrase = Localizator.localizedPopoverValue("popover.title.passphrase")
    }

    enum Description {
      static let teamId = Localizator.localizedPopoverValue("popover.description.teamId")
      static let keyId = Localizator.localizedPopoverValue("popover.description.keyId")
      static let bundleId = Localizator.localizedPopoverValue("popover.description.bundleId")
      static let destination = Localizator.localizedPopoverValue("popover.description.destination")
      static let environment = Localizator.localizedPopoverValue("popover.description.environment")
      static let notificationId = Localizator.localizedPopoverValue("popover.description.notificationId")
      static let expiration = Localizator.localizedPopoverValue("popover.description.expiration")
      static let priority = Localizator.localizedPopoverValue("popover.description.priority")
      static let collapseId = Localizator.localizedPopoverValue("popover.description.collapseId")
      static let kind = Localizator.localizedPopoverValue("popover.description.kind")
      static let payload = Localizator.localizedPopoverValue("popover.description.payload")
      static let passphrase = Localizator.localizedPopoverValue("popover.description.passphrase")
    }
  }

  static func localizedPopoverValue(
    _ key: String,
    tableName: String = "Popover",
    bundle: Bundle = .main
  ) -> String {
    NSLocalizedString(
      key,
      tableName: tableName,
      bundle: bundle,
      value: .empty,
      comment: .empty
    )
  }
}
