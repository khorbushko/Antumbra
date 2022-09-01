//
//  silverDeerApp.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import SwiftUI

import ComposableArchitecture

@main
struct SilverDeerApp: App {
  var body: some Scene {
    WindowGroup {
        RootView(
          store: Store(
            initialState: .init(),
            reducer: RootReducer.defaultReducer,
            environment: .live
          )
        )
        .navigationTitle(Localizator.Main.appTitle)
        .fixedSize()
        .onReceive(
          NotificationCenter.default
            .publisher(for: NSApplication.willUpdateNotification),
          perform: { _ in
            for window in NSApplication.shared.windows {
              window.standardWindowButton(.zoomButton)?.isEnabled = false
            }
          }
        )
    }
    .windowStyle(HiddenTitleBarWindowStyle())
  }
}
