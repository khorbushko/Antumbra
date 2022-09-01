//
//  SessionView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SessionView: View {
  let store: Store<SessionState, SessionAction>

  init(
    store: Store<SessionState, SessionAction>
  ) {
    self.store = store
  }

  var body: some View {
    NavigationView {
      DetailsView(store: store)
      HistoryView(store: store)
    }
    .navigationViewStyle(.automatic)
  }
}

#if DEBUG

struct SessionViewPreview: PreviewProvider {
  static var previews: some View {
    SessionView(
      store: Store(
        initialState: .init(session: .init(name: .empty)),
        reducer: SessionReducer.defaultReducer,
        environment: .preview
      )
    )
  }
}

#endif

