//
//  Alamofire+Request.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire
import Foundation

extension Alamofire.Request: Cancellable {

  var receivedPreconditionFailedError: Bool {
    if let response = task?.response as? HTTPURLResponse {
      return response.statusCode == NSHTTPURLResponsePreconditionFailedStatusCode
    }
    return false
  }

  var receivedForbiddenError: Bool {
    if let response = task?.response as? HTTPURLResponse {
      return response.statusCode == NSHTTPURLResponseForbiddenStatusCode
    }
    return false
  }
}
