//
//  MainView.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation
import SwiftUI

struct MainView: View {
  var body: some View {
    NavigationView {
      SideMenuView()
    }
    .navigationViewStyle(DoubleColumnNavigationViewStyle())
  }
}
