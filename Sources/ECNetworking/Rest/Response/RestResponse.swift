//
//  APIResponse.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Foundation

public protocol RestResponse: APIResponse {

  associatedtype Data

  var data: Data? { get }

  var error: APIError? { get }
  var sessionId: String? { get }
  var isSucceeded: Bool? { get }
  var message: String? { get }
  var executionTime: Int? { get }
}

public extension RestResponse {

  var data: Data? {
    return nil
  }

  var isFailure: Bool {
    return !isSuccess
  }

  var isSuccess: Bool {
    return error == nil
  }
}
