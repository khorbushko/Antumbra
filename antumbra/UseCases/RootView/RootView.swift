//
//  RootView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct RootView: View {
  let store: Store<RootState, RootAction>

  init(
    store: Store<RootState, RootAction>
  ) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in

      NavigationView {
        SideBarView(
          store: store.scope(
            state: \.sideBarState,
            action: RootAction.sideBarAction
          )
        )
        .background(Color.app.Background.secondary)
        .toolbar {
          ToolbarItem(placement: .navigation) {
            Button(action: {
              viewStore.send(.onToogleSidePanel)
            }) {
              Image.Session.Toolbar.hidePannel
            }
            .keyboardShortcut("L", modifiers: .command)
            .help(Localizator.Main.Hints.Toolbar.hideSideBar)
          }
        }

      }
      .frame(width: 1000, height: 600)
      .background(Color.app.Background.primary)
    }
  }
}

#if DEBUG

struct RootViewPreview: PreviewProvider {
  static var previews: some View {
    RootView(
      store: Store(
        initialState: .init(),
        reducer: RootReducer.defaultReducer,
        environment: .preview
      )
    )
  }
}

#endif
