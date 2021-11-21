//
//  ContentView.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import SwiftUI
import AppKit
import Combine

struct P8SessionData: Codable, Identifiable, Hashable {

  var id: String {
    token + deviceToken + serverEnv.url
  }

  let token: String
  let p8Key: String
  let teamId: String
  let keyId: String
  let bundleId: String
  let pushPayload: String
  let deviceToken: String
  let serverEnv: PushEnvironment
}

fileprivate final class P8ContentViewModel: ObservableObject {

  @Published var token: String?
  @Published var error: String?
  @Published var response: String = ""
  @Published var isLoading: Bool = false

  @Published var fileURL: URL?
  @Published var p8Key: String = ""
  @Published var popoverType: PopoverInfo = .none
  @Published var teamId: String = ""
  @Published var keyId: String = ""
  @Published var bundleId: String = ""
  @Published var deviceToken: String = ""
  @Published var serverType: PushEnvironment = .sandbox
  @Published var state: PushPredefinedType = .static
  @Published var pushPayload: String = PushPredefinedType.static.content

  private var sessionData: P8SessionData?

  private var tokens: Set<AnyCancellable> = []

  init(sessionData: P8SessionData? = nil) {
    if let sessionData = sessionData {
      token = sessionData.token
      p8Key = sessionData.p8Key
      teamId = sessionData.teamId
      keyId = sessionData.keyId
      bundleId = sessionData.bundleId
      pushPayload = sessionData.pushPayload
      deviceToken = sessionData.deviceToken
      serverType = sessionData.serverEnv
    }

    setupObservation()
  }

  // MARK: - Functions

  func copyP8() {
    if !p8Key.isEmpty {
      let pasteboard = NSPasteboard.general
      pasteboard.clearContents()
      pasteboard.setString(p8Key, forType: .string)
    }
  }

  func sendPush() {
    if let token = token,
        !token.isEmpty {
      if let jwtToken = try? JWTToken(raw: token, type: .access),
         jwtToken.isExpired {
        createToken(keyID: keyId, teamID: teamId, p8: p8Key)
        self.appendToResponse("Token expired, regenerated" + (self.token ?? ""))
      } else {
        self.appendToResponse("Token reused")
      }
    } else {
      createToken(keyID: keyId, teamID: teamId, p8: p8Key)
      self.appendToResponse("Token generated " + (self.token ?? ""))
    }

    if let token = token,
       let url = URL(string: "\(serverType.url)/3/device/" + deviceToken) {

      do {
        let payloadDictionary = try pushPayload.toDictionary()
        let postPayload = try JSONSerialization.data(
          withJSONObject: payloadDictionary as Any,
          options: []
        )

        var request = URLRequest(
          url: url,
          cachePolicy: .useProtocolCachePolicy,
          timeoutInterval: 10.0
        )
        request.httpMethod = "POST"
        request.httpBody = postPayload
        request.allHTTPHeaderFields = [
          "authorization": "bearer \(token)",
          "apns-topic": bundleId,
          "apns-priority": "10",
          "apns-push-type": "alert",
          "Content-Type": "application/json"
        ]

        self.isLoading = true

        URLSession.shared.dataTaskPublisher(for: request)
          .receive(on: DispatchQueue.main)
          .sink { completion in
            switch completion {
              case .failure(let error):
                self.error = error.localizedDescription
                self.appendToResponse(
                  "Failed to sent push" + error.localizedDescription
                )

              case .finished:
                break
            }
          } receiveValue: { (data: Data, response: URLResponse) in
            if let string = String(data: data, encoding: .utf8) {
              self.appendToResponse("Push sent" + string)
            }

            self.isLoading = false
          }
          .store(in: &tokens)
      } catch {
        self.error = "malformed payload \(error.localizedDescription)"
        self.appendToResponse(
          "malformed payload \(error.localizedDescription)"
        )
      }

    } else {
      self.appendToResponse("invalid url")
    }
  }

  // MARK: - Private

  private func readFile(_ fileURL: URL?) -> String? {
    if let path = fileURL?.path {
      return try? String(contentsOfFile: path)
    } else {
      return ""
    }
  }

  private func appendToResponse(_ string: String) {
    let prevResponse = self.response

    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let dateString = formatter.string(from: Date())

    self.response = "\(dateString) " + string
    self.response += "\n"
    self.response += prevResponse
  }

  private func createToken(
    keyID: String,
    teamID: String,
    p8: String
  ) {
    let jwt = JWT(
      keyID: keyID,
      teamID: teamID,
      issueDate: Date(),
      expireDuration: 60 * 60
    )

    do {
      let token = try jwt.sign(with: p8)
      self.token = token
    } catch {
      self.error = error.localizedDescription
      self.appendToResponse(
        "Generate token error \(error.localizedDescription)"
      )
    }
  }

  // MARK: - Utils

  private func setupObservation() {
    $state
      .sink { _ in

      } receiveValue: { pushPredefinedType in
        self.pushPayload = pushPredefinedType.content
      }
      .store(in: &tokens)

    $fileURL
      .sink { _ in

      } receiveValue: { url in
        if let key = self.readFile(url),
           !key.isEmpty {
          self.p8Key = key
        }
      }
      .store(in: &tokens)
  }
}

struct P8ContentView: View {
  @StateObject private var viewModel: P8ContentViewModel

  init(sessionData: P8SessionData? = nil) {
    _viewModel = StateObject(
      wrappedValue: .init(sessionData: sessionData)
    )
  }

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        dropArea()
        infoArea()
      }

      errorView()
    }
    .frame(width: 500, height: 500)
    .padding()
    .onChange(of: viewModel.error) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        viewModel.error = nil
      }
    }
  }

  // MARK: - Private

  @ViewBuilder
  private func errorView() -> some View {
    if let error = viewModel.error {
      HStack(spacing: 0) {
        Text(error)
          .multilineTextAlignment(.leading)
        Spacer()
      }
    }
  }

  @ViewBuilder
  private func infoAreaInputContent() -> some View {
    Group {
      HStack {
        TextField(
          PopoverInfo.teamId.placeholder,
          text: $viewModel.teamId
        )

        Button {
          viewModel.popoverType = .teamId
        } label: {
          Image(systemName: "questionmark.circle")
        }
        .popover(
          isPresented: .constant(viewModel.popoverType == .teamId),
          arrowEdge: .bottom
        ) {
          PopoverView(kind: .teamId)
        }
      }
      HStack {
        TextField(
          PopoverInfo.keyId.placeholder,
          text: $viewModel.keyId
        )

        Button {
          viewModel.popoverType = .keyId
        } label: {
          Image(systemName: "questionmark.circle")
        }
        .popover(
          isPresented: .constant(viewModel.popoverType == .keyId),
          arrowEdge: .bottom
        ) {
          PopoverView(kind: .keyId)
        }
      }
      HStack {
        TextField(
          PopoverInfo.bundleId.placeholder,
          text: $viewModel.bundleId
        )

        Button {
          viewModel.popoverType = .bundleId
        } label: {
          Image(systemName: "questionmark.circle")
        }
        .popover(
          isPresented: .constant(viewModel.popoverType == .bundleId),
          arrowEdge: .bottom
        ) {
          PopoverView(kind: .bundleId)
        }
      }

      TextField("Device token", text: $viewModel.deviceToken)
    }
    .padding(.bottom, 4)
  }

  private func infoArea() -> some View {
    VStack(spacing: 0) {
      infoAreaInputContent()

      HStack(alignment: .top, spacing: 0) {
        VStack {

          Picker("Environment", selection: $viewModel.serverType, content: {
            Text("sandbox").tag(PushEnvironment.sandbox)
            Text("production").tag(PushEnvironment.production)
          })
            .padding(.horizontal)

          Picker("Payload", selection: $viewModel.state, content: {
            Text("default").tag(PushPredefinedType.static)
            Text("localized").tag(PushPredefinedType.localized)
            Text("custom").tag(PushPredefinedType.customData)
          })
            .pickerStyle(.segmented)
            .padding(.horizontal)

          ScrollView {
            TextEditor(text: $viewModel.pushPayload)
              .disableAutocorrection(true)
              .background(Color.white)
              .frame(height: 150)
              .padding(.vertical, 2)
          }
          .shadow(radius: 1)
          .padding(.horizontal, 1)
        }

        VStack {
          Spacer()
          Button {
            viewModel.sendPush()
          } label: {
            Text("Send")
          }

          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .black))
            .opacity(viewModel.isLoading ? 1 : 0)
        }
        .padding()
      }

      HStack(alignment: .top, spacing: 0) {
        VStack {
          ScrollView {
            TextEditor(text: .constant(viewModel.response))
              .disableAutocorrection(true)
              .background(Color.gray.opacity(0.2))
              .frame(height: 60)
              .allowsHitTesting(false)
              .padding(.vertical, 2)
          }
        }
      }
      .padding(.vertical, 8)
    }
  }

  private func dropArea() -> some View {
    DroppableArea(fileURL: $viewModel.fileURL)
      .overlay(
        VStack(spacing: 0) {
          Text("Drop *.p8 file here")
          Image(systemName: "filemenu.and.cursorarrow")
            .resizable()
            .frame(width: 32, height: 32)
            .padding()
        }
          .opacity(viewModel.p8Key.isEmpty ? 1 : 0)
      )
      .overlay(
        VStack(spacing: 0) {
          ZStack {
            Text(viewModel.p8Key)
              .multilineTextAlignment(.center)
              .lineLimit(nil)
              .minimumScaleFactor(0.5)
            VStack(spacing: 0) {
              Spacer()
              HStack {
                Spacer()
                Button {
                  viewModel.fileURL = nil
                } label: {
                  Text("clear")
                }
                Button {
                  viewModel.copyP8()
                } label: {
                  Text("copy")
                }
              }
            }
          }
        }
          .opacity(viewModel.p8Key.isEmpty ? 0 : 1)
          .padding()
      )
      .frame(height: 100)
  }
}

// MARK: - Preview

struct P8ContentView_Previews: PreviewProvider {
  static var previews: some View {
    P8ContentView()
  }
}
