//
//  LoadingCirclesView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation
import SwiftUI

public struct LoadingCirclesView: View {

  private let indicatorCount: Int
  private let indicatorColor: Color
  @State private var animationFlag = false

  public init(
    indicatorCount: Int = 3,
    indicatorColor: Color
  ) {
    self.indicatorCount = indicatorCount
    self.indicatorColor = indicatorColor
  }

  public var body: some View {
    HStack {
      ForEach((0..<indicatorCount), id: \.self) { idx in
        Circle()
          .fill(indicatorColor)
          .frame(width: 12, height: 12)
          .animation(.none, value: animationFlag)
          .opacity(animationFlag ? 1 : 0)
          .animation(
            .easeInOut(duration: 0.5)
            .repeatForever()
            .delay(Double(idx) * 0.5 / Double(indicatorCount)),
            value: animationFlag
          )
      }
    }
    .onAppear {
      self.animationFlag = true
    }
  }
}

#if DEBUG

struct LoadingCirclesView_Preview: PreviewProvider {
  static var previews: some View {
    LoadingCirclesView(indicatorCount: 3, indicatorColor: Color.blue)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}

#endif
