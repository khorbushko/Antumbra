//
//  PushResponse.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

struct PushResponse: Codable, Identifiable, Equatable {
  struct APNSFailure: Codable, Equatable {
    enum Reason: String, Codable {
      case badCollapseID = "BadCollapseId"
      case badDeviceToken = "BadDeviceToken"
      case badExpirationdate = "BadExpirationDate"
      case badMessageId = "BadMessageId"
      case badPriority = "BadPriority"
      case badTopic = "BadTopic"
      case deviceTokenNotForTopic = "DeviceTokenNotForTopic"
      case dublicatedHeaders = "DuplicateHeaders"
      case idleTimeout = "IdleTimeout"
      case invalidPushType = "InvalidPushType"
      case missingDeviceToken = "MissingDeviceToken"
      case missingTopic = "MissingTopic"
      case payloadEmpty = "PayloadEmpty"
      case topicDisallowed = "TopicDisallowed"
      case badCertificate = "BadCertificate"
      case badCertificateEnvironment = "BadCertificateEnvironment"
      case expiredProviderToken = "ExpiredProviderToken"
      case forbidden = "Forbidden"
      case invalidProviderToken = "InvalidProviderToken"
      case missingProviderToken = "MissingProviderToken"
      case badPath = "BadPath"
      case methodNotAllowed = "MethodNotAllowed"
      case unregistered = "Unregistered"
      case payloadTooLarge = "PayloadTooLarge"
      case tooManyProviderTokenUpdates = "TooManyProviderTokenUpdates"
      case tooManyRequests = "TooManyRequests"
      case internalServerError = "InternalServerError"
      case serviceUnavailable = "ServiceUnavailable"
      case shutdown = "Shutdown"

      var description: String {
        switch self {
          case .badCollapseID:
            return "The collapse identifier exceeds the maximum allowed size."
          case .badDeviceToken:
            return "The specified device token is invalid. Verify that the request contains a valid token and that the token matches the environment."
          case .badExpirationdate:
            return "The apns-expiration value is invalid."
          case .badMessageId:
            return "The apns-id value is invalid."
          case .badPriority:
            return "The apns-priority value is invalid"
          case .badTopic:
            return "The apns-topic value is invalid."
          case .deviceTokenNotForTopic:
            return "The device token doesn’t match the specified topic."
          case .dublicatedHeaders:
            return "One or more headers are repeated."
          case .idleTimeout:
            return "Idle timeout"
          case .invalidPushType:
            return "The apns-push-type value is invalid."
          case .missingDeviceToken:
            return "The device token isn’t specified in the request :path. Verify that the :path header contains the device token."
          case .missingTopic:
            return "The apns-topic header of the request isn’t specified and is required. The apns-topicheader is mandatory when the client is connected using a certificate that supports multiple topics."
          case .payloadEmpty:
            return "The message payload is empty."
          case .topicDisallowed:
            return "Pushing to this topic is not allowed."
          case .badCertificate:
            return "The certificate is invalid."
          case .badCertificateEnvironment:
            return "The client certificate is for the wrong environment."
          case .expiredProviderToken:
            return "The provider token is stale and a new token should be generated."
          case .forbidden:
            return "The specified action is not allowed."
          case .invalidProviderToken:
            return "The provider token is not valid, or the token signature can't be verified."
          case .missingProviderToken:
            return "No provider certificate was used to connect to APNs, and the authorization header is missing or no provider token is specified."
          case .badPath:
            return "The request contained an invalid :path value."
          case .methodNotAllowed:
            return "The specified :method value isn’t POST."
          case .unregistered:
            return "The device token is inactive for the specified topic. There is no need to send further pushes to the same device token, unless your application retrieves the same device token, see Registering Your App with APNs"
          case .payloadTooLarge:
            return "The message payload is too large. For information about the allowed payload size, see Create and Send a POST Request to APNs."
          case .tooManyProviderTokenUpdates:
            return "The provider’s authentication token is being updated too often. Update the authentication token no more than once every 20 minutes."
          case .tooManyRequests:
            return "Too many requests were made consecutively to the same device token."
          case .internalServerError:
            return "An internal server error occurred."
          case .serviceUnavailable:
            return "The service is unavailable."
          case .shutdown:
            return "The APNs server is shutting down."
        }
      }
    }

    let reason: Reason
  }

  struct PushRequest: Codable, Equatable {
    let endPoint: String
    let path: String
    let headers: [String: String]
    let payload: String

    let date: Date
    let curl: String

    var deviceToken: String {
      path.components(separatedBy: "/3/device/").last ?? .dash
    }

    var server: String {
      endPoint.components(separatedBy: "/3/device/").first ?? .dash
    }

    var apnsCollapseId: String? {
      headers["apns-collapse-id"]
    }

    var apnsId: String? {
      headers["apns-id"]
    }

    var expiration: String? {
      headers["apns-expiration"]
    }

    var bundleId: String? {
      headers["apns-topic"]
    }

    var priority: String? {
      headers["apns-priority"]
    }

    var kind: String? {
      headers["apns-push-type"]
    }
  }

  struct PushResponse: Codable, Equatable {
    let headers: [String: String]
    let statusCode: HTTPStatusCode
    let failure: APNSFailure?

    var apnsId: String? {
      headers["apns-id"]
    }
  }

  let id: UUID
  let data: Data
  let authMethod: String
  let request: PushRequest
  let response: PushResponse

  var requestDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.YYYY | HH:mm"
    let string = formatter.string(from: self.request.date)
    return string
  }

  var isSuccess: Bool {
    response.failure == nil
  }

  // MARK: - Lifecycle

  init?(
    request: URLRequest,
    response: URLResponse,
    data: Data,
    authMethod: String
  ) {
    if let endPoint = request.url?.absoluteString,
       let path = request.url?.path,
       let headers = request.allHTTPHeaderFields,
       let payload = request.httpBody?.prettyPrintedJSONString,

        let httpResponse = response as? HTTPURLResponse,
       let responseHaders = httpResponse.allHeaderFields as? [String: String],
       let statusCode = HTTPStatusCode(HTTPResponse: httpResponse) {

      self.id = .init()
      self.data = data
      self.authMethod = authMethod
      self.request = .init(
        endPoint: endPoint,
        path: path,
        headers: headers,
        payload: payload,
        date: .init(),
        curl: request.curlString as String
      )

      self.response = PushResponse(
        headers: responseHaders,
        statusCode: statusCode,
        failure: try? JSONDecoder().decode(APNSFailure.self, from: data)
      )

    } else {
      return nil
    }
  }
}
