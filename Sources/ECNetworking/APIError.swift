//
//  APIError.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Foundation
import ObjectMapper

public struct APIError: LocalizedError, CustomNSError, ImmutableMappable {

  public let code: String
  public let description: String

  public init(map: Map) throws {
    code = try map.value("errorCode")
    description = try map.value("errorMessage")
  }

  public func mapping(map: Map) {
    code >>> map["errorCode"]
    description >>> map["errorMessage"]
  }

  public init(code: String, description: String) {
    self.code = code
    self.description = description
  }

  public static let `default` = APIError(code: "-1", description: "Something went wrong!")
}
