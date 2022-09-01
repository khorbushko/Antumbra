//
//  PushType.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation

enum PushPredefinedType: Int, Equatable, Codable, Hashable, CaseIterable {
  case simple
  case badge
  case localized
  case customData
  case alert
  case sound
  case backgroundUpdate
  case actions
  case critical
  case silent
  case mutableContent

  var content: String {
    switch self {
      case .simple:
        return """
{
  "aps" : {
    "alert" : {
      "title" : "Push handle",
      "body" : "This is a test message"
    }
  }
}
"""

      case .badge:
        return """
{
  "aps" : {
    "alert" : {
      "title" : "Push handle",
      "body" : "This is a test message"
    },
    "badge": 5
  }
}
"""

      case .localized:
        return """
{
  "aps": {
    "alert": {
      "title-loc-key": "notification.title",
      "loc-key": "notification.message",
      "loc-args": [
        "Hello from Push handle"
      ]
    }
  }
}
"""
      case .customData:
        return """
{
  "aps": {
    "alert" : {
      "title" : "Push handle",
      "body" : "This is a test message"
    },
    "badge": 5
  },
  "acme1": "bar",
  "acme2": [
    "bang",
    "whiz"
  ],
  "coords": {
    "latitude": 37.33182,
    "longitude": -122.03118
  }
}
"""
      case .alert:
        return """
{
    "aps" : {
      "alert" : {
        "title" : "Push handle",
        "body" : "This is a test message"
       }
    }
}
"""
      case .sound:
        return """
{
  "aps": {
    "sound": "bingbong.aiff"
  }
}
"""
      case .backgroundUpdate:
        return """
{
  "aps": {
    "content-available": 1
  }
}
"""

      case .actions:
        return """
{
  "aps": {
    "alert": {
      "title": "Push handle",
      "body": "This is a test message"
    },
    "category": "NEW_MESSAGE_CATEGORY",
    "importantId" : "123456789",
    "userId" : "ABCD1234"
  }
}
"""

      case .critical:
        return """
{
  "aps": {
    "alert" : {
      "title" : "Push handle",
      "body" : "This is a test message"
    },
    "sound": {
      "critical": 1,
      "name": "filename.caf",
      "volume": 0.75
    }
  }
}
"""

      case .silent:
        return """
{
  "content_available": true,
  "data": {
    "some-key": "some-value"
  }
}
"""

      case .mutableContent:
        return """
{
  "aps": {
    "alert" : {
      "title" : "Push handle",
      "body" : "This is a test message"
    },
    "mutable-content": 1
  },
  "request_url": "https://placekitten.com/200/300"
}
"""

    }

  }
}


