//
//  APIResponse.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import ObjectMapper

public protocol APIResponse: Mappable {

  var error: APIError? { get }

  var isFailure: Bool { get }
  var isSuccess: Bool { get }
}

public extension APIResponse {

  func throwErrorIfFailure() throws {
    if isFailure { throw error! }
  }
}
