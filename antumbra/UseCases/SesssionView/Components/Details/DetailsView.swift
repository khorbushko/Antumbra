//
//  DetailsView.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 18.08.2022.
//

import Foundation
import SwiftUI
import LottieContainer

import ComposableArchitecture
import CodeViewer

struct DetailsView: View {
  let store: Store<SessionState, SessionAction>

  init(
    store: Store<SessionState, SessionAction>
  ) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        viewHeader(viewStore: viewStore)
        tabContent(viewStore: viewStore)
        viewFooter(viewStore: viewStore)
      }
    }
  }

  // MARK: - Private

  private func viewHeader(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    HStack {
      TextField(
        text: viewStore.binding(
          get: \.session.name,
          send: { SessionAction.onChange(.sessionName($0)) }
        )
      ) { }
        .textFieldStyle(PlainTextFieldStyle())
        .background(Color.clear)
        .adaptiveFont(.appItalic, size: 10)
        .padding(.leading, 4)
        .overlay(
          HStack {
            Divider()
              .frame(width: 3)
              .background(Color.app.Hightlight.indicator)
            Spacer()
          }
            .padding(.leading, -1)
            .padding(.vertical, -4)
        )
    }
    .padding()
    .frame(height: 44)
  }

  private func tabContent(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    ScrollView {
      VStack {
        authPanel(viewStore: viewStore)
        environmentPanel(viewStore: viewStore)
        destinationPanel(viewStore: viewStore)
        headerPanel(viewStore: viewStore)
        bodyPanel(viewStore: viewStore)

        Spacer(minLength: 0)
      }
      .padding()
      .frame(minWidth: 575, maxWidth: .infinity, maxHeight: .infinity)
    }
    .overlay(
      VStack {
        LinearGradient(
          colors: [
            Color.app.Background.primary,
            Color.app.Background.primary.opacity(0)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 16)

        Spacer(minLength: 0)

        LinearGradient(
          colors: [
            Color.app.Background.primary,
            Color.app.Background.primary.opacity(0)
          ],
          startPoint: .bottom,
          endPoint: .top
        )
        .frame(height: 16)
      }
    )
  }

  @ViewBuilder
  private func authPanel(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    ExpandableView(
      title: SessionState.Sections.auth.title,
      expand: viewStore.binding(
        get: \.isAuthSectionExpanded,
        send: { _ in
          SessionAction.onToogleExpandStateFor(.auth)
        })
    ) {
      HStack(spacing: 0) {
        SegmentControlView(
          indicatorColor: .app.Hightlight.indicator,
          selectedItemTint: .app.Hightlight.text,
          unSelectedItemTint: .app.Text.primary,
          items: viewStore.authTypes,
          selection: viewStore.binding(
            get: \.selectedAuthType,
            send: SessionAction.onChangeAuthType
          )
        )
        .padding(.vertical, 2)
        .frame(width: 100)

        Spacer()
      }

      VStack {
        authArea(viewStore: viewStore)
          .transition(.move(edge: .trailing).combined(with: .opacity))
      }
      .animation(.linear, value: viewStore.selectedAuthType)
    }
  }

  @ViewBuilder
  private func authArea(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    switch viewStore.selectedAuthType {
      case .p8:
        p8DropArea(viewStore: viewStore)
        inputFor(.teamId, viewStore: viewStore) {
          textFiledInputFor(.teamId, viewStore: viewStore)
        }
        inputFor(.keyId, viewStore: viewStore) {
          textFiledInputFor(.keyId, viewStore: viewStore)
        }

      case .p12:
        p12DropArea(viewStore: viewStore)
        inputFor(.passphrase, viewStore: viewStore) {
          textFiledInputFor(.passphrase, viewStore: viewStore)
        }

      case .keychain:
        keychainCertsArea(viewStore: viewStore)
    }
  }

  @ViewBuilder
  private func keychainCertsArea(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    VStack {
      ScrollView(.vertical) {
          VStack(spacing: 0) {
            ForEach(0..<viewStore.certificates.count, id: \.self) { idx in
              let element = viewStore.certificates[idx]
              let isSelected = viewStore.selectedCertificate == element

              let backgroundColor = idx % 2 == 0
                ? Color.app.Control.Background.secondary.opacity(0.25)
                : Color.app.Control.Background.secondary.opacity(0.5)

              if idx != 0 {
                ZStack {
                  Divider()
                }
                .frame(height: 1)
              }

              CertView(
                element: element,
                isSelected: isSelected,
                backgroundColor: backgroundColor
              )
              .onTapGesture {
                viewStore.send(.onChange(.onSelectKeychainCert(element)))
              }
              .animation(.linear, value: viewStore.selectedCertificate)
            }
        }

        Spacer()
      }
    }
    .roundedCorners(radius: 6, corners: .allCorners)
    .frame(height: 225)
    .onAppear {
      viewStore.send(.onFetchKeychainCerts)
    }
  }

  @ViewBuilder
  private func p8DropArea(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    DroppableArea<ConcreteDropDelegate>(
      fileType: viewStore.selectedAuthType.fileExtension,
      fileURL: viewStore.binding(
        get: { _ in nil },
        send: { SessionAction.onChange(.p8URL($0)) }
      ),
      colorFailure: .app.State.failure.opacity(0.3),
      colorSuccess: .app.State.success.opacity(0.3),
      inactiveColor: .clear
    )
    .frame(height: 150)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(
          style: StrokeStyle(
            lineWidth: 1,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 1,
            dash: [4],
            dashPhase: 10
          )
        )
    )
    .mask(RoundedRectangle(cornerRadius: 12))
    .overlay(
      HStack(spacing: 0) {
        VStack {
          Spacer()

          HStack {
            Button(Localizator.Session.Details.Pane.Auth.Action.selectFileP8) {
              let panel = NSOpenPanel()
              panel.allowsMultipleSelection = false
              panel.canChooseDirectories = false
              panel.canChooseFiles = true
              if panel.runModal() == .OK {
                viewStore.send(.onChange(.p8URL(panel.url)))
              }
            }
            .buttonStyle(ScaleAndOpacityButtonStyleNoAnimation(type: .secondary))
            .frame(width: 200)

            Spacer()
          }

          HStack {
            Text(Localizator.Session.Details.Pane.Auth.messageP8)
              .foregroundColor(Color.app.Text.primary.opacity(0.5))
              .adaptiveFont(.appRegular, size: 10)
            Spacer()
          }

          Spacer()
        }
        .padding(.horizontal)

        VStack(alignment: .leading, spacing: 4) {
          Spacer()
          Text(viewStore.session.pushData.info.p8Identity.fileName ?? .empty)
            .foregroundColor(Color.app.Text.primary)
            .adaptiveFont(.appBold, size: 8)

          Text(viewStore.session.pushData.info.p8Identity.fileContent?.prefix(100) ?? "")
            .foregroundColor(Color.app.Text.primary)
            .adaptiveFont(.appRegular, size: 6)
            .multilineTextAlignment(.leading)
            .allowsTightening(true)

          HStack {
            Spacer(minLength: 0)
            Button {
              viewStore.send(.onCopyAuthAction(.p8))
            } label: {
              Image.Session.General.copy
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 24)
                .foregroundColor(Color.app.Image.secondary.opacity(0.25))
                .opacity(viewStore.playCopyAnimation ? 0 : 1)
            }
            .increaseTapArea()
            .buttonStyle(PlainButtonStyle())
            .opacity(viewStore.session.pushData.info.p8Identity.fileContent != nil ? 1 : 0)
            .overlay(
              Group {
                if viewStore.playCopyAnimation {
                  LottieAnimationView(animation: .copySuccess, loopMode: .playOnce)
                    .frame(width: 80, height: 80)
                }
              }
            )
          }
        }
        .padding()

        Spacer(minLength: 0)
      }
    )
    .padding(.bottom, 16)
  }

  @ViewBuilder
  private func p12DropArea(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    DroppableArea<ConcreteDropDelegate>(
      fileType: viewStore.selectedAuthType.fileExtension,
      fileURL: viewStore.binding(
        get: { _ in nil },
        send: { SessionAction.onChange(.p12URL($0)) }
      ),
      colorFailure: .app.State.failure.opacity(0.3),
      colorSuccess: .app.State.success.opacity(0.3),
      inactiveColor: .clear
    )
    .frame(height: 150)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(
          style: StrokeStyle(
            lineWidth: 1,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 1,
            dash: [4],
            dashPhase: 10
          )
        )
    )
    .mask(RoundedRectangle(cornerRadius: 12))
    .overlay(
      HStack(spacing: 0) {
        VStack {
          Spacer()

          HStack {
            Button(Localizator.Session.Details.Pane.Auth.Action.selectFileP12) {
              let panel = NSOpenPanel()
              panel.allowsMultipleSelection = false
              panel.canChooseDirectories = false
              panel.canChooseFiles = true
              if panel.runModal() == .OK {
                viewStore.send(.onChange(.p12URL(panel.url)))
              }
            }
            .buttonStyle(ScaleAndOpacityButtonStyleNoAnimation(type: .secondary))
            .frame(width: 200)

            Spacer()
          }

          HStack {
            Text(Localizator.Session.Details.Pane.Auth.messageP12)
              .foregroundColor(Color.app.Text.primary.opacity(0.5))
              .adaptiveFont(.appRegular, size: 10)
            Spacer()
          }

          Spacer()
        }
        .padding(.horizontal)

        VStack(alignment: .leading, spacing: 4) {
          Spacer()
          Text(viewStore.session.pushData.info.p12Identity.fileName ?? .empty)
            .foregroundColor(Color.app.Text.primary)
            .adaptiveFont(.appBold, size: 8)
          Spacer()
        }
        .padding()

        Spacer(minLength: 0)
      }
    )
    .padding(.bottom, 16)
  }


  @ViewBuilder
  private func destinationPanel(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    ExpandableView(
      title: SessionState.Sections.destination.title,
      expand: viewStore.binding(
        get: \.isDestinationSectionExpanded,
        send: { _ in
          SessionAction.onToogleExpandStateFor(.destination)
        })
    ) {
      inputFor(.destination, viewStore: viewStore) {
        textFiledInputFor(.destination, viewStore: viewStore)
      }
    }
  }

  @ViewBuilder
  private func headerPanel(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    ExpandableView(
      title: SessionState.Sections.header.title,
      expand: viewStore.binding(
        get: \.isHeaderSectionExpanded,
        send: { _ in
          SessionAction.onToogleExpandStateFor(.header)
        })
    ) {

      inputFor(.bundleId, viewStore: viewStore) {
        textFiledInputFor(.bundleId, viewStore: viewStore)
      }

      inputFor(.priority, viewStore: viewStore) {
        pickerInputFor(
          .priority,
          viewStore.binding(
            get: \.pushPriority,
            send: { SessionAction.onChange(.priority($0)) }
          )
        ) {
          ForEach(viewStore.supportedPushPriority, id: \.self) {
            Text($0.name)
              .tag($0)
              .foregroundColor(Color.app.Text.primary)
              .adaptiveFont(.appRegular, size: 10)
          }
        }
        .pickerStyle(.radioGroup)
        .horizontalRadioGroupLayout()
      }

      inputFor(.kind, viewStore: viewStore) {
        pickerInputFor(
          .kind,
          viewStore.binding(
            get: \.pushType,
            send: { SessionAction.onChange(.pushType($0)) }
          )
        ) {
          ForEach(viewStore.supportedPushType, id: \.self) {
            Text($0.name)
              .tag($0)
              .foregroundColor(Color.app.Text.primary)
              .adaptiveFont(.appRegular, size: 10)
          }
        }
        .pickerStyle(.menu)
        .background(Color.app.Background.secondary)
        .padding(.trailing, 8)
      }

      inputFor(.notificationId, viewStore: viewStore) {
        textFiledInputFor(.notificationId, viewStore: viewStore)
      }

      inputFor(.expiration, viewStore: viewStore) {
        textFiledInputFor(.expiration, viewStore: viewStore)
      }

      inputFor(.collapseId, viewStore: viewStore) {
        textFiledInputFor(.collapseId, viewStore: viewStore)
      }
    }
  }

  @ViewBuilder
  private func environmentPanel(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    ExpandableView(
      title: SessionState.Sections.environment.title,
      expand: viewStore.binding(
        get: \.isEnvironmentSectionExpanded,
        send: { _ in
          SessionAction.onToogleExpandStateFor(.environment)
        })
    ) {
      inputFor(.environment, viewStore: viewStore) {
        pickerInputFor(
          .environment,
          viewStore.binding(
            get: \.pushEnvironment,
            send: { SessionAction.onChange(.pushEnvironment($0)) }
          )
        ) {
          ForEach(viewStore.supportedPushEnv, id: \.self) {
            Text($0.name)
              .tag($0)
              .foregroundColor(Color.app.Text.primary)
              .adaptiveFont(.appRegular, size: 10)
          }
        }
        .pickerStyle(.radioGroup)
        .horizontalRadioGroupLayout()
      }
    }
  }

  @ViewBuilder
  private func bodyPanel(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    ExpandableView(
      title: SessionState.Sections.body.title,
      expand: viewStore.binding(
        get: \.isBodySectionExpanded,
        send: { _ in
          SessionAction.onToogleExpandStateFor(.body)
        })
    ) {
      inputFor(.payload, viewStore: viewStore) {
        pickerInputFor(
          .payload,
          viewStore.binding(
            get: \.selectedPushPayload,
            send: { SessionAction.onChange(.payloadType($0)) }
          )
        ) {
          ForEach(viewStore.pushPayloads, id: \.self) {
            Text($0.name)
              .tag($0)
              .foregroundColor(Color.app.Text.primary)
              .adaptiveFont(.appRegular, size: 10)
          }
        }
        .pickerStyle(.menu)
        .background(Color.app.Background.secondary)
        .padding(.trailing, 8)
      }

      VStack {
        // workaround to fix CodeViewer Binding issue ...
        let content = {
          CodeViewer(
            content: viewStore.binding(
              get: \.pushPayload,
              send: { SessionAction.onChange(.payload($0))}
            ),
            mode: .json,
            darkTheme: .tomorrow_night,
            lightTheme: .dawn,
            isReadOnly: false,
            fontSize: 13
          )
          .background(Color.app.Background.secondary)
          .roundedCorners(radius: 6, corners: .allCorners)
        }
        switch viewStore.selectedPushPayload {
          case .simple:
            content()
          case .localized:
            content()
          case .customData:
            content()
          case .alert:
            content()
          case .badge:
            content()
          case .sound:
            content()
          case .backgroundUpdate:
            content()
          case .actions:
            content()
          case .critical:
            content()
          case .silent:
            content()
          case .mutableContent:
            content()
        }

        HStack {
          Spacer()
          Text(viewStore.formattedPayloadSize)
            .foregroundColor(
              viewStore.isPayloadExceedLimit
                ? Color.app.State.failure.opacity(0.5)
                : Color.app.Text.hightlighed.opacity(0.5)
            )
            .adaptiveFont(.appRegular, size: 8)
        }
      }
      .padding(.vertical)
      .frame(height: 300)
      .shadow(
        color: Color.app.Control.Tint.primary,
        radius: 6
      )
    }
  }

  private func viewFooter(
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    HStack {

      VStack(alignment: .leading, spacing: 0) {
        Text(viewStore.failMessage ?? .dash)
          .foregroundColor(Color.app.State.failure)
          .adaptiveFont(.appRegular, size: 6)
          .lineLimit(3)
          .opacity(viewStore.showFail ? 1 : 0)
      }

      Spacer()

      LoadingButton(
        action: {
          viewStore.send(.onExecute)
        }, label: {
          Text(Localizator.Session.Details.Action.send)
        },
        isLoading: viewStore.isLoading,
        buttonStyle: .primary,
        padding: 0
      )
      .frame(width: 125)
      .disabled(!viewStore.canSendRequest)
    }
    .padding()
  }

  // MARK: - Popover

  @ViewBuilder
  private func inputFor<C: View>(
    _ type: PopoverInfo,
    viewStore: ViewStore<SessionState, SessionAction>,
    @ViewBuilder content: () -> C
  ) -> some View {
    Spacer(minLength: 0)
      .frame(height: 8)
    VStack(alignment: .leading) {
      HStack(spacing: 0) {
        Text(type.title)
          .foregroundColor(Color.app.Text.primary)
          .adaptiveFont(.appBold, size: 6)

        if type.isMandatory {
          Text(String.asterics)
            .foregroundColor(Color.app.Hightlight.indicator)
            .adaptiveFont(.appBold, size: 6)
        }

        Button {
          viewStore.send(.onShowPopover(type))
        } label: {
          Image.Session.General.info
            .renderingMode(.template)
            .resizable()
            .frame(width: 14, height: 14)
            .foregroundColor(Color.app.Image.secondary.opacity(0.25))
        }
        .increaseTapArea()
        .buttonStyle(PlainButtonStyle())
        .popover(
          isPresented: viewStore.binding(
            get: {_ in  viewStore.popoverType == type},
            send: SessionAction.onHidePopover
          ),
          arrowEdge: .top
        ) {
          PopoverView(kind: type)
        }
        .padding(.horizontal, 8)

        Spacer(minLength: 0)
      }

      content()
    }
  }

  @ViewBuilder
  private func textFiledInputFor(
    _ type: PopoverInfo,
    viewStore: ViewStore<SessionState, SessionAction>
  ) -> some View {
    TextField(
      type.placeholder,
      text: viewStore.binding(
        get: { state in
          switch type {
            case .teamId:
              return state.teamId
            case .bundleId:
              return state.bundleId
            case .keyId:
              return state.keyId
            case .destination:
              return state.apnsToken

            case .notificationId:
              return state.notificationId
            case .expiration:
              return state.expiration
            case .collapseId:
              return state.collapseId

            case .passphrase:
              return state.passphrase

            case .none,
                .priority,
                .kind,
                .environment,
                .payload:
              return .empty
          }
        },
        send: {
          switch type {
            case .teamId:
              return SessionAction.onChange(.teamId($0))
            case .bundleId:
              return SessionAction.onChange(.bundleId($0))
            case .keyId:
              return SessionAction.onChange(.keyId($0))
            case .destination:
              return SessionAction.onChange(.apnsToken($0))

            case .passphrase:
              return SessionAction.onChange(.passphrase($0))

            case .notificationId:
              return SessionAction.onChange(.notificationId($0))
            case .expiration:
              return SessionAction.onChange(.expiration(Int($0) ?? 0))
            case .collapseId:
              return SessionAction.onChange(.collapseId($0))

            case .none,
                .priority,
                .kind,
                .environment,
                .payload:
              break
          }
          fatalError()
        }
      )
    )
    .textFieldStyle(PlainTextFieldStyle())
    .padding(6)
    .background(Color.app.Control.Background.secondary)
    .roundedCorners(
      radius: 6,
      corners: .allCorners
    )
    .shadow(
      color: Color.app.Control.Tint.primary,
      radius: 4,
      x: 2,
      y: 2
    )
  }

  @ViewBuilder
  private func pickerInputFor<C: View, T: Equatable & Hashable>(
    _ type: PopoverInfo,
    _ binding: Binding<T>,
    @ViewBuilder content: () -> C
  ) -> some View{
    Picker(
      String.empty,
      selection: binding,
      content: content
    )
    .accentColor(Color.app.Control.Tint.secondary)
  }
}
