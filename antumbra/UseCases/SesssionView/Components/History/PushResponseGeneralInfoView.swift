//
//  PushResponseGeneralInfoView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 29.08.2022.
//

import Foundation
import SwiftUI

struct PushResponseGeneralInfoView: View {
  let data: PushResponse
  let onCopyAction: (String) -> Void

  var body: some View {
    VStack(alignment: .leading) {

      CopyView(
        title: Localizator.Session.HistoryView.General.endpoint,
        value: data.request.server,
        onCopyAction: onCopyAction
      )

      CopyView(
        title: Localizator.Session.HistoryView.General.deviceToken,
        value: data.request.deviceToken,
        onCopyAction: onCopyAction
      )

      CopyView(
        title: Localizator.Session.HistoryView.General.APNSId,
        value: data.response.apnsId ?? .dash,
        onCopyAction: onCopyAction
      )

      Text("Auth method")
        .foregroundColor(Color.app.Text.primary)
        .adaptiveFont(.appRegular, size: 8)

      Text(data.authMethod)
        .foregroundColor(Color.app.Text.primary.opacity(0.5))
        .adaptiveFont(.appRegular, size: 6)
      .adaptiveFont(.appBold, size: 10)
      .padding(.bottom, 12)

      Text(Localizator.Session.HistoryView.General.status)
        .foregroundColor(Color.app.Text.primary)
        .adaptiveFont(.appRegular, size: 8)

      Text(
        data.isSuccess
        ? Localizator.Session.HistoryView.General.success
        : Localizator.Session.HistoryView.General.fail
      )
      .foregroundColor(
        data.isSuccess
        ? Color.app.State.success
        : Color.app.State.failure
      )
      .adaptiveFont(.appBold, size: 10)

      Spacer()
    }
    .padding(4)
  }
}
