//
//  SideMenuView.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation
import SwiftUI

final class Page: Identifiable, Equatable, Hashable, ObservableObject {
  var session: P8SessionData?
  var id = UUID()
  @Published var name: String
  @Published var selectedIndex: Int = 0

  static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
  }

  init(name: String, session: P8SessionData? = nil) {
    self.session = session
    self.name = name
  }
}

final class SideMenuViewModel: ObservableObject {
  @Published var pages: [Page] = []
  @Published var selectedPage: Page?

  init() {
    pages = [
      .init(name: "session-1")
    ]

    selectedPage = pages.first
  }

  func addNewSession() {
    pages.append(.init(name: "session-\(pages.count+1)"))
  }
}

struct SideMenuView: View {
  @StateObject private var viewModel: SideMenuViewModel = .init()

  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Text("Config")
          .font(.subheadline)
        Spacer()
      }
      .padding(.horizontal, 8)

      List(viewModel.pages) { page in
        NavigationLink(
          destination: content(page),
          tag: page,
          selection: $viewModel.selectedPage
        ) {
          TextField("session", text: .init(get: { page.name }, set: { page.name = $0 } ))
        }
      }

      Divider()

      VStack {
        HStack {
          Spacer()
          Button {
            viewModel.addNewSession()
          } label: {
            Image(systemName: "plus.app")
              .resizable()
              .frame(width: 16, height: 16)
          }
          .buttonStyle(.plain)
          .padding(4)
        }
        Spacer()
      }
      .frame(height: 22)
    }
  }

  @ViewBuilder
  private func content(_ page: Page) -> some View {
    PushTabView(page: page)
      .padding()
  }
}

struct PushTabView: View {
  @State var page: Page

  var body: some View {
    TabView(selection: $page.selectedIndex) {
      P8ContentView(sessionData: page.session)
      .tabItem {
        HStack {
          Text("p8")
        }
        .frame(width: 100)
      }
      .tag(0)

      HStack {
        Spacer()
        VStack {
          Spacer()
          Text("p12")
          Spacer()
        }
        Spacer()
      }
      .frame(width: 500, height: 500)
      .padding()
      .tabItem {
        HStack {
          Text("p12")
        }
        .frame(width: 100)
      }
      .tag(1)
    }
  }
}
