//
//  PushType.swift
//  pushHandle
//
//  Created by Kyryl Horbushko on 06.11.2021.
//

import Foundation

enum PushPredefinedType: Int {
  case `static` = 0
  case localized
  case customData

  var content: String {
    switch self {
      case .static:
        return """
{
  "aps" : {
    "alert" : {
      "title" : "Push handle",
      "body" : "This is a test message",
    },
    "badge" : 5
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
    "aps" : {
        "alert" : {
            "title" : "Game Request",
            "body" : "Bob wants to play poker",
            "action-loc-key" : "PLAY"
        },
        "badge" : 5
    },
    "acme1" : "bar",
    "acme2" : [ "bang",  "whiz" ]
}
"""
    }
  }
}
