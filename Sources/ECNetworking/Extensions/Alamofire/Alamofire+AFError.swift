//
//  Alamofire+AFError.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire

public let NSHTTPURLResponseBadRequestStatusCode: Int = 400
public let NSHTTPURLResponseForbiddenStatusCode: Int = 403
public let NSHTTPURLResponsePreconditionFailedStatusCode: Int = 412
public let NSHTTPURLResponsePinCodeNeededStatusCode: Int = 424

public extension Alamofire.AFError {

  var receivedPreconditionFailed: Bool {
    return responseCode == NSHTTPURLResponsePreconditionFailedStatusCode
  }

  var receivedForbidden: Bool {
    return responseCode == NSHTTPURLResponseForbiddenStatusCode
  }

  var receivedPinCodeNeeded: Bool {
    return responseCode == NSHTTPURLResponsePinCodeNeededStatusCode
  }

  var receivedAuthenticationFailed: Bool {
    return receivedPreconditionFailed || receivedForbidden
  }
}
