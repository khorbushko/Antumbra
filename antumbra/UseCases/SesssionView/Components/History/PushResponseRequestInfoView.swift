//
//  PushResponseRequestInfoView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 29.08.2022.
//

import Foundation
import SwiftUI

import CodeViewer

struct PushResponseRequestInfoView: View {
  let data: PushResponse
  let onCopyAction: (String) -> Void

  var body: some View {
    VStack(alignment: .leading) {

      Group {
        CopyView(
          title: Localizator.Session.HistoryView.Request.endpoint,
          value: data.request.server,
          onCopyAction: onCopyAction
        )

        CopyView(
          title: Localizator.Session.HistoryView.Request.url,
          value: data.request.endPoint,
          onCopyAction: onCopyAction
        )

        CopyView(
          title: Localizator.Session.HistoryView.Request.bundleId,
          value: data.request.bundleId ?? .dash,
          onCopyAction: onCopyAction
        )
      }

      Text(Localizator.Session.HistoryView.Request.headers)
        .foregroundColor(Color.app.Text.primary)
        .adaptiveFont(.appRegular, size: 8)
      let keys = Array(data.request.headers.keys)
      ForEach(0..<keys.count, id: \.self) { idx in
        let key = keys[idx]
        HeaderView(key: key, value: data.request.headers[key]!)
      }

      Spacer(minLength: 12)
        .frame(maxHeight: 12)

      Text(Localizator.Session.HistoryView.Request.payload)
        .foregroundColor(Color.app.Text.primary)
        .adaptiveFont(.appRegular, size: 8)

      CodeViewer(
        content: .constant(data.request.payload),
        mode: .json,
        darkTheme: .tomorrow_night,
        lightTheme: .dawn,
        isReadOnly: true,
        fontSize: 8
      )
      .frame(height: 100)

      if data.authMethod == Session.AuthProviderInfo.AuthType.p8.fileExtension {
        CopyView(
          title: Localizator.Session.HistoryView.Request.curl,
          value: data.request.curl,
          onCopyAction: onCopyAction
        )
      }
    }
    .padding(4)
  }
}

