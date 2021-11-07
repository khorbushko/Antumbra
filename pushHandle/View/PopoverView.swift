//
//  PopoerView.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation
import SwiftUI

enum PopoverInfo: Equatable {
  case none
  case teamId
  case keyId
  case bundleId

  var imageName: String {
    switch self {
      case .teamId:
        return "teamID"
      case .keyId:
        return "keyID"
      case .bundleId:
        return "bundleID"

      case .none:
        return ""
    }
  }

  var placeholder: String {
    switch self {
      case .teamId:
        return "TEAM ID"
      case .keyId:
        return "KEY ID"
      case .bundleId:
        return "BUNDLE ID"
      case .none:
        return ""
    }
  }

  var link: String {
    switch self {
      case .teamId:
        return "https://developer.apple.com/account/ios/authkey/"
      case .keyId:
        return "https://developer.apple.com/account/resources/authkeys"
      case .bundleId:
        return "https://appstoreconnect.apple.com/apps"
      case .none:
        return ""
    }
  }
}

struct PopoverView: View {
  let kind: PopoverInfo

  var body: some View {
    VStack {
      Text("You can obtains this info here: ")
        .padding()
      Image(kind.imageName)
        .resizable()
        .frame(width: 450, height: 200)
      Link(
        destination: URL(string: kind.link)!) {
          HStack {
            Text("Navigate")
            Image(systemName: "link")
          }
        }
        .padding()
    }
  }
}
