//
//  SegmentView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 20.08.2022.
//

import Foundation
import SwiftUI

public struct SegmentControlView<T: Equatable & RawRepresentable>: View where T.RawValue: StringProtocol {

  @Binding private var selection: T
  @State private var segmentSize: CGSize = .zero
  @State private var itemTitleSizes: [CGSize] = []

  private let items: [T]

  private let indicatorColor: Color
  private let selectedItemTint: Color
  private let unSelectedItemTint: Color

  public init(
    indicatorColor: Color,
    selectedItemTint: Color,
    unSelectedItemTint: Color,
    items: [T],
    selection: Binding<T>
  ) {
    self.indicatorColor = indicatorColor
    self.selectedItemTint = selectedItemTint
    self.unSelectedItemTint = unSelectedItemTint

    self._selection = selection
    self.items = items
    self._itemTitleSizes = State(
      initialValue: [CGSize](
        repeating: .zero,
        count: items.count
      )
    )
  }

  public var body: some View {
    ZStack {
      GeometryReader { geometry in
        Color
          .clear
          .onAppear {
            segmentSize = geometry.size
          }
      }
      .frame(maxWidth: .infinity, maxHeight: 1)

      VStack(alignment: .center, spacing: 0) {
        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: xSpace) {
            ForEach(0 ..< items.count, id: \.self) { index in
              segmentItemView(for: index)
            }
          }

          Rectangle()
            .foregroundColor(indicatorColor)
            .frame(width: selectedItemWidth, height: 3)
            .offset(x: selectedItemHorizontalOffset(), y: 0)
            .animation(.linear(duration: 0.3), value: selection)
        }
        .padding(.horizontal, xSpace)
      }
    }
  }

  private var indexOfSelectedItem: Int {
    items.firstIndex(of: selection) ?? 0
  }

  private var selectedItemWidth: CGFloat {
    itemTitleSizes.count > indexOfSelectedItem
    ? itemTitleSizes[indexOfSelectedItem].width
    : .zero
  }

  @ViewBuilder
  private func segmentItemView(for index: Int) -> some View {
    if index < items.count {
      let isSelected = self.selection == items[index]

      Text(items[index].rawValue)
        .font(.caption)
        .foregroundColor(isSelected ? selectedItemTint : unSelectedItemTint)
        .background(BackgroundGeometryReader())
        .onPreferenceChange(BackgroundGeometryReader.SizePreferenceKey.self) {
          itemTitleSizes[index] = $0
        }
        .onTapGesture { onItemTap(index: index) }
    } else {
      EmptyView()
    }
  }

  private func onItemTap(index: Int) {
    guard index < items.count else { return }
    self.selection = items[index]
  }

  private var xSpace: CGFloat {
    guard !itemTitleSizes.isEmpty,
            !items.isEmpty,
            segmentSize.width != 0 else {
      return 0
    }
    let itemWidthSum: CGFloat = itemTitleSizes
      .map { $0.width }
      .reduce(0, +)
      .rounded()
    let space = (segmentSize.width - itemWidthSum) / CGFloat(items.count + 1)
    return max(space, 0)
  }

  private func selectedItemHorizontalOffset() -> CGFloat {
    guard selectedItemWidth != .zero,
          indexOfSelectedItem != 0 else {
      return 0
    }

    let result = itemTitleSizes
      .enumerated()
      .filter { $0.offset < indexOfSelectedItem }
      .map { $0.element.width }
      .reduce(0, +)

    return result + xSpace * CGFloat(indexOfSelectedItem)
  }
}
