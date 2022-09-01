//
//  PushProcessor.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation
import Combine

import Security

final class PushSender {
  enum Failure: Error {
    case nonCompleteData
    case certificateReadFail
    case unexpectedResponse
    case incorrectFlow
    case system(Error)
  }

  static let sender: PushSender = .init()
  private let storage: TokenStorage = SessionStore.store
  private let networkSession: URLSession
  private var sessionDelegate: PushSenderNetworkDelegate = .init()

  private init() {
    networkSession = URLSession(
      configuration: .default,
      delegate: sessionDelegate,
      delegateQueue: .main
    )
  }

  // MARK: - Public

  // MARK: - P8 push

  func sendPushWith(_ session: Session) -> AnyPublisher<PushResponse, Error> {

    let fail: () -> AnyPublisher<PushResponse, Error> = {
      Fail(error: Failure.nonCompleteData)
        .eraseToAnyPublisher()
    }

    if session.pushData.canSendPush,
       let apnsToken = session.apnsToken {

      switch session.info.type {
        case .p8:
          if let keyID = session.pushData.info.p8Identity.keyId,
             let teamID = session.pushData.info.p8Identity.teamId,
             let p8Key = session.pushData.info.p8Identity.fileContent {

            return storage.fetchTokensFor(teamID: teamID, keyID: keyID)
              .catch { _ in
                self.generateSignedJWTTokenPublisher(
                  keyID: keyID,
                  teamID: teamID,
                  p8Key: p8Key
                )
              }
              .flatMap { token -> AnyPublisher<JWTToken, Error> in
                if token.isExpired {
                  return self.generateSignedJWTTokenPublisher(
                    keyID: keyID,
                    teamID: teamID,
                    p8Key: p8Key
                  )
                } else {
                  return Just(token)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                }
              }
              .flatMap(storage.addToken)
              .flatMap { token in
                self.p8PushDataTaskFor(
                  session: session,
                  token: token,
                  apnsToken: apnsToken
                )
              }
              .eraseToAnyPublisher()

          } else {
            return fail()
          }

        case .p12,
            .keychain:

          return Future<Bool, Error> { promise in
            let error = self.sessionDelegate.updateCredentialsFor(session)
            if let error = error {
              promise(.failure(error))
            } else {
              promise(.success(true))
            }
          }
          .eraseToAnyPublisher()
          .flatMap { isSuccessReadCert -> AnyPublisher<PushResponse, Error> in
            if isSuccessReadCert {
              return self.pushDataTaskFor(
                type: session.info.type,
                session: session,
                apnsToken: apnsToken
              )
            } else {
              return Fail(error: Failure.certificateReadFail)
                .eraseToAnyPublisher()
            }
          }
          .eraseToAnyPublisher()
      }
    } else {
      return fail()
    }
  }

  // MARK: - Private

  private func p8PushDataTaskFor(
    session: Session,
    token: JWTToken,
    apnsToken: String
  ) -> AnyPublisher<PushResponse, Error> {
    if let url = session.endPoint,
       let payloadDictionaryData = session.payloadData {

      var headers = [
        "Authorization": "Bearer \(token.raw)",
      ]
      headers += session.headers

      var request = URLRequest(
        url: url,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 5.0
      )
      request.httpMethod = "POST"
      request.httpBody = payloadDictionaryData
      request.allHTTPHeaderFields = headers

      return URLSession.shared.dataTaskPublisher(for: request)
        .tryMap { dataPair in
          if let pushResponse = PushResponse(
            request: request,
            response: dataPair.response,
            data: dataPair.data,
            authMethod: Session.AuthProviderInfo.AuthType.p8.fileExtension
          ) {
              return pushResponse
          } else {
            throw Failure.unexpectedResponse
          }
        }
        .mapError({ fail in
          Failure.system(fail)
        })
        .eraseToAnyPublisher()
    } else {
      return Fail(error: Failure.nonCompleteData)
        .eraseToAnyPublisher()
    }
  }

  private func generateSignedJWTToken(
    keyID: String,
    teamID: String,
    p8Key: String
  ) throws -> String {
    let jwtTokenFresh = JWT(
      keyID: keyID,
      teamID: teamID,
      issueDate: Date(),
      expireDuration: 60 * 60
    )

    let signedJWTToken = try jwtTokenFresh.sign(with: p8Key)
    return signedJWTToken
  }

  private func generateSignedJWTTokenPublisher(
    keyID: String,
    teamID: String,
    p8Key: String
  ) -> AnyPublisher<JWTToken, Error> {
    Deferred {
      Future<JWTToken, Error> { promise in
        if let token = try? self.generateSignedJWTToken(
          keyID: keyID,
          teamID: teamID,
          p8Key: p8Key
        ),
           let jwt = try? JWTToken(raw: token, type: .access) {
          promise(.success(jwt))
        } else {
          promise(.failure(Failure.nonCompleteData))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  // MARK: - P12 & Keychain cert
  private func pushDataTaskFor(
    type: Session.AuthProviderInfo.AuthType,
    session: Session,
    apnsToken: String
  ) -> AnyPublisher<PushResponse, Error> {

    if !(type == .keychain || type == .p12) {
      return Fail(error: Failure.incorrectFlow)
        .eraseToAnyPublisher()
    } else {

      if type == .keychain || type == .p12,
         let url = session.endPoint,
         let payloadDictionaryData = session.payloadData {

        var request = URLRequest(
          url: url,
          cachePolicy: .useProtocolCachePolicy,
          timeoutInterval: 5.0
        )
        request.httpMethod = "POST"
        request.httpBody = payloadDictionaryData
        request.allHTTPHeaderFields = session.headers

        return networkSession.dataTaskPublisher(for: request)
          .tryMap { dataPair in
            if let pushResponse = PushResponse(
              request: request,
              response: dataPair.response,
              data: dataPair.data,
              authMethod: type.rawValue
            ) {
              return pushResponse
            } else {
              throw Failure.unexpectedResponse
            }
          }
          .mapError({ fail in
            Failure.system(fail)
          })
          .eraseToAnyPublisher()

      } else {
        return Fail(error: Failure.nonCompleteData)
          .eraseToAnyPublisher()
      }
    }
  }
}

final class PushSenderNetworkDelegate: NSObject, URLSessionDelegate {
  enum Failure: Error {
    case system(Error)
    case secPKCS12ImportFail
    case dataIncomplete
    case identityFail
  }

  private var credentials: URLCredential?

  // MARK: - P12

  func updateCredentialsFor(_ session: Session) -> Error? {
    if session.pushData.info.type == .p12,
       session.pushData.canSendPush {
      if let p12Data = session.pushData.info.p12Identity.fileData,
         let pass = session.pushData.info.p12Identity.passphrase {
        do {
          let p12SecIdentity = try identityWith(p12Data, passphrase: pass)
          if let secIdentity = p12SecIdentity {
            var cert : SecCertificate?
            SecIdentityCopyCertificate(secIdentity, &cert)
            if let cert = cert {
              let credentials = URLCredential(
                identity: secIdentity,
                certificates: [cert],
                persistence: .forSession
              )

              self.credentials = credentials
              return nil
            }
          }
        } catch {
          return error
        }
      }

      return Failure.identityFail

    } else if session.pushData.info.type == .keychain,
              let credentials = session.pushData.info.cert?.urlCredentials {
      self.credentials = credentials
      return nil
    }

    return Failure.dataIncomplete
  }

  // MARK: - URLSessionDelegate

  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {

    completionHandler(.useCredential, credentials)
  }

  // MARK: - Private

  private func identityWith(
    _ PKCS12Data: Data,
    passphrase: String
  ) throws -> SecIdentity? {

    let key: String = kSecImportExportPassphrase as String
    let options = [key: passphrase]

    var items : CFArray?
    let ossStatus = SecPKCS12Import(PKCS12Data as CFData, options as CFDictionary, &items)
    guard ossStatus == errSecSuccess else {
      throw Failure.secPKCS12ImportFail
    }

    if let arr = items {
      if CFArrayGetCount(arr) > 0 {
        let newArray = arr as [AnyObject]
        if !newArray.isEmpty {
          let dictionary = newArray[0]
          let secIdentity = dictionary.value(forKey: kSecImportItemIdentity as String) as! SecIdentity
          return secIdentity
        }
      }
    }

    throw Failure.dataIncomplete
  }
}
