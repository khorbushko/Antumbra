//
//  Localizator+Session.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation

extension Localizator {
  enum Session {
    static let defaultName = Localizator.sessionLV("session.details.defaultName")

    enum Details {
      enum Action {
        static let send = Localizator.sessionLV("session.details.action.send")
      }

      enum Pane {
        enum Auth {
          static let messageP8 = Localizator.sessionLV("session.details.pane.auth.message.p8")
          static let messageP12 = Localizator.sessionLV("session.details.pane.auth.message.p12")

          enum Action {
            static let selectFileP8 = Localizator.sessionLV("session.details.pane.auth.action.p8.selectFile")
            static let selectFileP12 = Localizator.sessionLV("session.details.pane.auth.action.p12.selectFile")
          }
        }
      }
    }

    enum Section {
      static let auth = Localizator.sessionLV("session.sections.auth")
      static let destination = Localizator.sessionLV("session.sections.destination")
      static let header = Localizator.sessionLV("session.sections.header")
      static let body = Localizator.sessionLV("session.sections.body")
      static let env = Localizator.sessionLV("session.sections.env")
    }

    enum Popover {
      enum Message {
        static let main = Localizator.sessionLV("popoverView.message.obtain")
        static let suffix = Localizator.sessionLV("popoverView.message.obtain.suffix")
      }
    }

    enum PushData {
      enum Priority {
        static let low = Localizator.sessionLV("session.pushData.pushPriority.low")
        static let normal = Localizator.sessionLV("session.pushData.pushPriority.normal")
        static let critical = Localizator.sessionLV("session.pushData.pushPriority.critical")
      }

      enum Kind {
        static let alert = Localizator.sessionLV("session.pushData.pushType.alert")
        static let background = Localizator.sessionLV("session.pushData.pushType.background")
        static let location = Localizator.sessionLV("session.pushData.pushType.location")
        static let voip = Localizator.sessionLV("session.pushData.pushType.voip")
        static let complication = Localizator.sessionLV("session.pushData.pushType.complication")
        static let fileprovider = Localizator.sessionLV("session.pushData.pushType.fileprovider")
        static let mdm = Localizator.sessionLV("session.pushData.pushType.mdm")
      }

      enum Env {
        static let sandbox = Localizator.sessionLV("session.pushData.environment.sandbox")
        static let production = Localizator.sessionLV("session.pushData.environment.production")
      }
    }

    enum PushPredefinedType {
      static let simple = Localizator.sessionLV("pushPredefinedType.simple")
      static let localized = Localizator.sessionLV("pushPredefinedType.localized")
      static let customData = Localizator.sessionLV("pushPredefinedType.customData")
      static let alert = Localizator.sessionLV("pushPredefinedType.alert")
      static let badge = Localizator.sessionLV("pushPredefinedType.badge")
      static let sound = Localizator.sessionLV("pushPredefinedType.sound")
      static let backgroundUpdate = Localizator.sessionLV("pushPredefinedType.backgroundUpdate")
      static let actions = Localizator.sessionLV("pushPredefinedType.actions")
      static let critical = Localizator.sessionLV("pushPredefinedType.critical")
      static let silent = Localizator.sessionLV("pushPredefinedType.silent")
      static let mutableContent = Localizator.sessionLV("pushPredefinedType.mutableContent")
    }

    enum HistoryView {
      static let noRequestsMesage = Localizator.sessionLV("session.historyView.noRequestsMesage")

      enum Tabs {
        static let request = Localizator.sessionLV("sessionState.HistoryTab.request")
        static let response = Localizator.sessionLV("sessionState.HistoryTab.response")
        static let general = Localizator.sessionLV("sessionState.HistoryTab.general")
      }

      enum General {
        static let endpoint = Localizator.sessionLV("historyView.general.endpoint")
        static let deviceToken = Localizator.sessionLV("historyView.general.deviceToken")
        static let APNSId = Localizator.sessionLV("historyView.general.APNSId")
        static let status = Localizator.sessionLV("historyView.general.status")
        static let success = Localizator.sessionLV("historyView.general.status.success")
        static let fail = Localizator.sessionLV("historyView.general.status.fail")
      }

      enum Request {
        static let endpoint = Localizator.sessionLV("historyView.request.endpoint")
        static let url = Localizator.sessionLV("historyView.request.url")
        static let bundleId = Localizator.sessionLV("historyView.request.bundleId")
        static let headers = Localizator.sessionLV("historyView.request.headers")
        static let payload = Localizator.sessionLV("historyView.request.payload")
        static let curl = Localizator.sessionLV("historyView.request.curl")
      }

      enum Response {
        static let statusCode = Localizator.sessionLV("historyView.response.statusCode")
        static let headers = Localizator.sessionLV("historyView.response.headers")
        static let data = Localizator.sessionLV("historyView.response.data")
        static let failure = Localizator.sessionLV("historyView.response.failure.reason")
      }
    }

    enum CertTab {
      static let expires = Localizator.sessionLV("session.certTab.expires")
    }
  }

  private static func sessionLV(_ key: String) -> String {
    Localizator.localizedValue(key, tableName: "Session")
  }
}
