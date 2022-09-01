//
//  SessionView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI

import ComposableArchitecture

struct SideBarView: View {

  let store: Store<SideBarState, SideBarAction>

  init(
    store: Store<SideBarState, SideBarAction>
  ) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {

        ScrollView(.vertical) {
          GeometryReader { proxy in
            VStack(spacing: 0) {
              ForEach(0..<viewStore.sessions.count, id: \.self) { idx in
                if idx != 0 {
                  ZStack {
                    Color.app.Background.secondary
                    Divider()
                  }
                  .frame(height: 1)
                }

                view(
                  viewStore: viewStore,
                  session: viewStore.sessions[idx],
                  position: idx
                )
              }
            }
          }

          Spacer()
        }

        bottomToolbar(viewStore: viewStore)
      }
      .background(Color.app.Background.secondary)
      .padding(.horizontal, 4)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }

  @ViewBuilder
  private func bottomToolbar(
    viewStore: ViewStore<SideBarState, SideBarAction>
  ) -> some View {
    Divider()

    VStack(spacing: 0) {
      HStack(spacing: 0) {

        Button {
          viewStore.send(.onNewSessionCreate)
        } label: {
          Image.SideBar.addSession
            .resizable()
            .frame(width: 16, height: 16)
        }
        .buttonStyle(.plain)
        .padding(4)

        Button {
          viewStore.send(.onRemoveSession)
        } label: {
          Image.SideBar.removeSession
            .resizable()
            .frame(width: 16, height: 16)
        }
        .buttonStyle(.plain)
        .opacity(viewStore.sessions.count > 1 ? 1 : 0.5)
        .allowsHitTesting(viewStore.sessions.count > 1)
        .padding(4)

        Spacer(minLength: 0)
      }
      Spacer(minLength: 0)
    }
    .frame(height: 28)
    .padding(.bottom, 4)
    .padding(.horizontal, 4)
  }

  @ViewBuilder
  private func view(
    viewStore: ViewStore<SideBarState, SideBarAction>,
    session: Session,
    position: Int
  ) -> some View {
    let isSelected = viewStore.selectedSessionID == session.id
    let fillColor: Color = isSelected ? .app.Hightlight.indicator.opacity(0.3) : .app.Hightlight.background.opacity(0.3)
    let foregroundColor: Color = isSelected ? .app.Text.hightlighed : .app.Text.primary

    Button {
      viewStore.send(.onSessionSelect(session.id))
    } label: {
      HStack {
        Label {
          Text(session.name)
            .adaptiveFont(.appRegular, size: 10)
            .foregroundColor(foregroundColor)
            .animation(nil, value: session.name)
        } icon: {
          session.icon.image
            .renderingMode(.template)
            .resizable()
            .frame(width: 22, height: 22)
            .foregroundColor(foregroundColor.opacity(0.5))
        }
        Spacer(minLength: 0)
      }
      .increaseTapArea()
    }
    .buttonStyle(.borderless)
    .tag(session.id)
    .frame(height: 26)
    .padding(.horizontal, 8)
    .background(fillColor)
    .roundedCorners(
      radius: 6,
      corners: RectCorner.cornersForElement(
        at: position,
        totalCount: viewStore.sessions.count
      )
    )
    .navigationLink(
      isPresented: viewStore.binding(
        get: { _ in viewStore.selectedSessionID == session.id },
        send: SideBarAction.onPopAction
      ),
      content: {
        IfLetStore(
          store.scope(
            state: \.sessionState,
            action: SideBarAction.sessionAction
          ),
          then: SessionView.init(store: )
        )
      }
    )
  }
}
