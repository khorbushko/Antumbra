//
//  File.swift
//  
//
//  Created by Kyryl Horbushko
//

import Foundation

protocol Cryptable {
  
  func encrypt(_ string: String) throws -> Data
  func decrypt(_ data: Data) throws -> String
}
