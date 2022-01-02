//
//  Error+Additions.swift
//  Networking
//
//  Created by Emre Çiftçi on 22.12.2021.
//

import Alamofire
import Foundation

public extension Error {

  var ns: NSError {
    return self as NSError
  }

  var code: Int {
    return ns.code
  }

  var asAPIError: APIError? {
    return self as? APIError
  }
}
