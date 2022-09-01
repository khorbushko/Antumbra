//
//  HistoryInfoView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 29.08.2022.
//

import Foundation
import SwiftUI

struct HistoryInfoView: View {
  enum HistoryTab: String, Equatable, CaseIterable {
    case general
    case request
    case response
  }

  enum Action {
    case delete(PushResponse)
    case copy(String)
  }

  let data: PushResponse
  let position: Int
  @State private var selectedTab: HistoryTab = .general
  let onAction: (Action) -> Void

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        SegmentControlView(
          indicatorColor: .app.Hightlight.indicator,
          selectedItemTint: .app.Hightlight.text,
          unSelectedItemTint: .app.Text.primary,
          items: HistoryTab.allCases,
          selection: $selectedTab
        )
        .padding(.vertical, 8)
        .frame(width: 175)
        Spacer()
      }
      .overlay(
        HStack {
          Spacer()
          Button(action: {
            withAnimation {
              onAction(.delete(data))
            }
          }, label: {
            Image.Session.History.remove
              .renderingMode(.template)
              .resizable()
              .frame(width: 16, height: 16)
              .foregroundColor(Color.app.Text.hightlighed.opacity(0.5))
          })
          .buttonStyle(.plain)
          .increaseTapArea()
          .frame(width: 44, height: 44)
        }
      )
      .overlay(
        HStack {
          Divider()
            .frame(width: 3)
            .background(Color.app.Hightlight.indicator)
          Spacer()
        }
      )

      Divider()

      Spacer()

      VStack {
        switch selectedTab {
          case .general:
            PushResponseGeneralInfoView(
              data: data,
              onCopyAction: { onAction(.copy($0)) }
            )
          case .request:
            PushResponseRequestInfoView(
              data: data,
              onCopyAction: { onAction(.copy($0)) }
            )
          case .response:
            PushResponseResponseInfoView(
              data: data,
              onCopyAction: { onAction(.copy($0)) }
            )
        }
      }
      .animation(.easeOut, value: selectedTab)

      Divider()
      HStack {

        Text("#\(position)")
          .foregroundColor(Color.app.Text.primary.opacity(0.5))
          .adaptiveFont(.appRegular, size: 8)

        Spacer()

        Text(data.requestDate)
          .foregroundColor(Color.app.Text.primary.opacity(0.5))
          .adaptiveFont(.appRegular, size: 6)
      }
      .padding(8)
    }
    .background(Color.app.Background.secondary)
    .roundedCorners(radius: 6, corners: .allCorners)
    .padding(.horizontal, 8)
    .shadow(
      color: Color.app.Control.Tint.primary,
      radius: 6
    )
    .id(data.id)
  }
}

extension HistoryInfoView.HistoryTab {

  var rawValue: String {
    switch self {
      case .request:
        return Localizator.Session.HistoryView.Tabs.request
      case .response:
        return Localizator.Session.HistoryView.Tabs.response
      case .general:
        return Localizator.Session.HistoryView.Tabs.general
    }
  }
}
