//
//  PushResponseResponseInfoView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 29.08.2022.
//

import Foundation
import SwiftUI

import CodeViewer

struct PushResponseResponseInfoView: View {
  let data: PushResponse
  let onCopyAction: (String) -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Text(Localizator.Session.HistoryView.Response.statusCode)
        .foregroundColor(Color.app.Text.primary)
        .adaptiveFont(.appRegular, size: 8)

      Text("\(data.response.statusCode.rawValue)")
        .foregroundColor(Color.app.Text.primary.opacity(0.5))
        .adaptiveFont(.appRegular, size: 6)
        .padding(.bottom, 12)

      Text(Localizator.Session.HistoryView.Response.headers)
        .foregroundColor(Color.app.Text.primary)
        .adaptiveFont(.appRegular, size: 8)
      let keys = Array(data.response.headers.keys)
      ForEach(0..<keys.count, id: \.self) { idx in
        let key = keys[idx]
        HeaderView(key: key, value: data.response.headers[key]!)
      }

      Spacer(minLength: 12)
        .frame(maxHeight: 12)

      if let response = data.data.prettyPrintedJSONString {
        Text(Localizator.Session.HistoryView.Response.data)
          .foregroundColor(Color.app.Text.primary)
          .adaptiveFont(.appRegular, size: 8)

        CodeViewer(
          content: .constant(response),
          mode: .json,
          darkTheme: .tomorrow_night,
          lightTheme: .dawn,
          isReadOnly: true,
          fontSize: 8
        )
        .frame(height: 50)
        .padding(.bottom, 12)
      }

      if let failure = data.response.failure {
        Text(Localizator.Session.HistoryView.Response.failure)
          .foregroundColor(Color.app.Text.primary)
          .adaptiveFont(.appRegular, size: 8)

        Text(failure.reason.description)
          .foregroundColor(Color.app.Text.primary.opacity(0.5))
          .adaptiveFont(.appRegular, size: 6)
          .padding(.bottom, 12)
      }
    }
    .padding(4)
  }
}
