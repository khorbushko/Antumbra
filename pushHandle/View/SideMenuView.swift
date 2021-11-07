//
//  SideMenuView.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation
import SwiftUI

final class Page: Identifiable, Equatable, Hashable {
  var session: P8SessionData?
  var id = UUID()
  var name: String

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

struct SideMenuView: View {
  private var pages: [Page] = []
  @State private var selectedPage: Page? = nil

  init() {
    pages = [
      .init(name: "P8")
    ]
  }

  var body: some View {
    VStack {
      HStack(spacing: 0) {
        Text("Config")
          .font(.subheadline)
        Spacer()
      }
      .padding(.horizontal, 8)

      List(pages) { page in
        NavigationLink(
          destination: P8ContentView(sessionData: page.session),
          tag: page,
          selection: $selectedPage
        ) {
          Text(page.name)
        }
      }
      .onAppear {
        selectedPage = pages.first
      }
    }
  }
}

