//
//  NavigationLinkModifier.swift
//  mehabTestCase
//
//  Created by Kyrylo Horbushko on 10.08.2022.
//

import Foundation
import SwiftUI

public struct NavigationLinkModifier<ContentView: View, Item: Hashable & Identifiable>: ViewModifier {

  private var item: Binding<Item?>
  private var presentedView: (Item) -> ContentView

  public init(
    item: Binding<Item?>,
    @ViewBuilder presentedView: @escaping (Item) -> ContentView
  ) {
    self.item = item
    self.presentedView = presentedView
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
      if let itemValue = item.wrappedValue {
        NavigationLink(
          destination: presentedView(itemValue),
          tag: itemValue,
          selection: item,
          label: { EmptyView() })
        .opacity(0)
      }
    }
  }
}

public struct NavigationLinkModifierBool<ContentView: View>: ViewModifier {
  private var isPresented: Binding<Bool>
  private var presentedView: () -> ContentView

  public init(
    isPresented: Binding<Bool>,
    @ViewBuilder presentedView: @escaping () -> ContentView
  ) {
    self.isPresented = isPresented
    self.presentedView = presentedView
  }

  public func body(content: Content) -> some View {
    ZStack {
      content
      NavigationLink(
        destination: presentedView(),
        isActive: isPresented,
        label: {
          EmptyView()
        })
      .opacity(0)
    }
  }
}

public extension View {

  func navigationLink<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      NavigationLinkModifierBool(
        isPresented: isPresented,
        presentedView: content
      )
    )
  }

  func navigationLink<Content: View, Item: Hashable & Identifiable>(
    item: Binding<Item?>,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    self.modifier(
      NavigationLinkModifier(
        item: item,
        presentedView: content
      )
    )
  }
}
