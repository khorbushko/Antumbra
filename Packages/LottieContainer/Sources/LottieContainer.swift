//
//  
//  LottieContainerCore.swift
//  authentificator (iOS)
//
//  Created by Kyryl Horbushko on 08.11.2021.
//
//

import Foundation
import SwiftUI
import Lottie

public enum LottieAnimation: Equatable {
  case copySuccess
  case emptySpace

  func nameFor(scheme: ColorScheme) -> String {
    switch self {
      case .copySuccess:
        switch scheme {
          case .light:
            return "success_star_light"
          case .dark:
            return "success_star_dark"
          @unknown default:
            return "success_star_light"
        }
      case .emptySpace:
        switch scheme {
          case .light:
            return "empty_light"
          case .dark:
            return "empty_dark"
          @unknown default:
            return "empty_light"
        }
    }
  }
}

public struct LottieAnimationView: View {
  public init(
    animation: LottieAnimation,
    loopMode: LottieView.PlayMode = .loop
  ) {
    self.animation = animation
    self.loopMode = loopMode
  }

  @Environment(\.colorScheme) private var scheme: ColorScheme

  private let animation: LottieAnimation
  private let loopMode: LottieView.PlayMode

  public var body: some View {
    LottieView(
      name: animation.nameFor(scheme: scheme),
      bundle: .module,
      loopMode: loopMode
    )
  }
}

#if os(iOS)
public struct LottieView: UIViewRepresentable {

  // to hide Lottie
  public enum PlayMode {
    case playOnce
    /// Animation will loop from beginning to end until stopped.
    case loop
    /// Animation will play forward, then backwards and loop until stopped.
    case autoReverse
    /// Animation will loop from beginning to end up to defined amount of times.
    case `repeat`(Float)
    /// Animation will play forward, then backwards a defined amount of times.
    case repeatBackwards(Float)
  }

  public init(
    name: String,
    bundle: Bundle = .main,
    loopMode: LottieView.PlayMode = .loop
  ) {
    self.name = name

    switch loopMode {
      case .autoReverse:
        self.loopMode = .autoReverse
      case .playOnce:
        self.loopMode = .playOnce
      case .loop:
        self.loopMode = .loop
      case .repeat(let count):
        self.loopMode = .repeat(count)
      case .repeatBackwards(let count):
        self.loopMode = .repeatBackwards(count)
    }
    self.bundle = bundle
  }

  private var name: String
  private var bundle: Bundle
  private var loopMode: LottieLoopMode = .playOnce
  private let animationView = AnimationView()

  public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
    let view = UIView(frame: .zero)

    animationView.animation = Animation.named(name, bundle: bundle)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = loopMode
    animationView.backgroundBehavior = .pauseAndRestore

    animationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(animationView)

    DispatchQueue.main.async {
      animationView.play()
    }

    NSLayoutConstraint.activate([
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
    ])

    return view
  }

  public func updateUIView(
    _ uiView: UIView,
    context: UIViewRepresentableContext<LottieView>
  ) {  }
}
#endif

#if os(macOS)

public struct LottieView: NSViewRepresentable {

  // to hide Lottie
  public enum PlayMode {
    case playOnce
    /// Animation will loop from beginning to end until stopped.
    case loop
    /// Animation will play forward, then backwards and loop until stopped.
    case autoReverse
    /// Animation will loop from beginning to end up to defined amount of times.
    case `repeat`(Float)
    /// Animation will play forward, then backwards a defined amount of times.
    case repeatBackwards(Float)
  }

  public init(
    name: String,
    bundle: Bundle = .main,
    loopMode: LottieView.PlayMode = .loop
  ) {
    self.name = name

    switch loopMode {
      case .autoReverse:
        self.loopMode = .autoReverse
      case .playOnce:
        self.loopMode = .playOnce
      case .loop:
        self.loopMode = .loop
      case .repeat(let count):
        self.loopMode = .repeat(count)
      case .repeatBackwards(let count):
        self.loopMode = .repeatBackwards(count)
    }
    self.bundle = bundle
  }

  private var name: String
  private var bundle: Bundle
  private var loopMode: LottieLoopMode = .playOnce
  private let animationView = AnimationView()

  public func makeNSView(context: NSViewRepresentableContext<LottieView>) -> NSView {
    let view = NSView(frame: .zero)
    return view
  }

  public func updateNSView(
    _ uiView: NSView,
    context: NSViewRepresentableContext<LottieView>
  ) {
    // The problem is with SwiftUI state refresh, workaround - reacreate on update
    uiView.subviews.forEach({ $0.removeFromSuperview() })
    let animationView = AnimationView()
    animationView.translatesAutoresizingMaskIntoConstraints = false
    uiView.addSubview(animationView)

    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
    ])

    animationView.animation = Animation.named(name, bundle: bundle)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = loopMode
    animationView.backgroundBehavior = .pauseAndRestore
    DispatchQueue.main.async {
      animationView.play()
    }
    animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    animationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}
#endif
