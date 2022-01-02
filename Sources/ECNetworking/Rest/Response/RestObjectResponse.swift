//
//  RestObjectResponse.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import ObjectMapper

open class RestObjectResponse<T: BaseMappable>: RestResponse, Promiseable {

  public typealias Data = T

  public var error: APIError?

  public var sessionId: String?
  public var isSucceeded: Bool?
  public var message: String?
  public var executionTime: Int?

  required public init?(map: Map) {
    error = try? map.value("error")
    sessionId = try? map.value("sessionId")
    isSucceeded = try? map.value("isSucceeded")
    message = try? map.value("message")
    executionTime = try? map.value("executionTime")
  }

  open func mapping(map: Map) {
    error <- map["error"]
    sessionId <- map["sessionId"]
    isSucceeded <- map["isSucceeded"]
    message <- map["message"]
    executionTime <- map["executionTime"]
  }
}
