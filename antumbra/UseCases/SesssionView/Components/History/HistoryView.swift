//
//  HistoryView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import LottieContainer
import CodeViewer

struct HistoryView: View {
  let store: Store<SessionState, SessionAction>

  init(
    store: Store<SessionState, SessionAction>
  ) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in

      GeometryReader { proxy in
        ScrollViewReader { scrollViewProxy in
          ScrollView {
            ForEach(0..<viewStore.historyItems.count, id: \.self) { idx in
              let element = viewStore.historyItems[idx]
              HistoryInfoView(data: element, position: idx) { action in
                switch action {
                  case .delete(let objectToRemove):
                    viewStore.send(.onHistoryViewAction(.delete(objectToRemove)))
                  case .copy(let value):
                    viewStore.send(.onCopyValue(value))
                }
              }
            }
            .padding(.vertical, 4)

          }
          .frame(width: proxy.size.width)
          .overlay(
            VStack(spacing: 0) {
              Spacer()

              LottieAnimationView(animation: .emptySpace)
                .frame(width: 120, height: 120)

              Text(Localizator.Session.HistoryView.noRequestsMesage)
                .foregroundColor(Color.app.Text.primary.opacity(0.5))
                .adaptiveFont(.appRegular, size: 10)
                .padding(.top, -30)

              Spacer()
            }
              .opacity(viewStore.historyItems.isEmpty ? 1 : 0)
          )
          .overlay(
            VStack {
              LinearGradient(
                colors: [
                  Color.app.Background.primary,
                  Color.app.Background.primary.opacity(0)
                ],
                startPoint: .top,
                endPoint: .bottom
              )
              .frame(height: 16)

              Spacer(minLength: 0)

              LinearGradient(
                colors: [
                  Color.app.Background.primary,
                  Color.app.Background.primary.opacity(0)
                ],
                startPoint: .bottom,
                endPoint: .top
              )
              .frame(height: 16)
            }
          )
          .blur(
            radius: proxy.size.width <= viewStore.historyViewVisibilityThreshould
            ? viewStore.historyViewVisibilityThreshould / 4 - proxy.size.width / 4
            : 0,
            opaque: false
          )
          .onChange(of: viewStore.historyItems, perform: { items in
            scrollListToBottomWith(scrollViewProxy, viewStore: viewStore)
          })
          .onAppear {
            scrollListToBottomWith(scrollViewProxy, viewStore: viewStore)
          }

        }
      }
      .frame(minWidth: 50)
      .padding(.vertical)
    }
  }

  private func scrollListToBottomWith(
    _ scrollViewProxy: ScrollViewProxy,
    viewStore: ViewStore<SessionState, SessionAction>
  ) {
    if let itemID = viewStore.historyItems.last?.id {
      Task {
        withAnimation(.easeOut) {
          scrollViewProxy.scrollTo(itemID, anchor: .bottom)
        }
      }
    }
  }
}
