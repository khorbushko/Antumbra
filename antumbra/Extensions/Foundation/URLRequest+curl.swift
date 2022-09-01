//
//  URLRequest+curl.swift
//  silverDeer
//
//  Created by Kyrylo Horbushko on 25.08.2022.
//

import Foundation

extension URLRequest {
  /**
   Returns a cURL command representation of this URL request.
   */
  public var curlString: NSString {
    guard let url = self.url else {
      return ""
    }

    var baseCommand = #"curl "\#(url.absoluteString)""#
    if self.httpMethod == "HEAD" {
      baseCommand += " --head"
    }
    var command = [baseCommand]
    if let method = self.httpMethod,
        method != "GET" && method != "HEAD" {
      command.append("-X \(method)")
    }
    if let headers = self.allHTTPHeaderFields {
      for (key, value) in headers where key != "Cookie" {
        command.append("-H '\(key): \(value)'")
      }
    }
    if let data = self.httpBody,
        let body = String(data: data, encoding: .utf8) {
      command.append("-d '\(body)'")
    }
    let result = command.joined(separator: " \\\n\t")
    let cleanUpString =  NSString(string: result)
    return cleanUpString
  }
}
