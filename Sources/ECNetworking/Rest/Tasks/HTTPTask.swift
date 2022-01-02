//
//  HTTPTask.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire
import Foundation

public protocol HTTPTask: CustomStringConvertible {

  var method: HTTPMethod { get }
  var additionalHeaders: [String: String] { get }

  var body: Parameters? { get }

  var path: String { get }
  var queryParameters: [URLQueryItem]? { get }

  var isSecure: Bool { get }
  var encoding: ParameterEncoding { get }
}

public extension HTTPTask {

  var encoding: ParameterEncoding {
    switch method {
    case .post, .put:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }

  var isSecure: Bool {
    return true
  }

  var additionalHeaders: [String: String] {
    return [:]
  }

  var queryParameters: [URLQueryItem]? {
    return nil
  }

  var scheme: String {
    let secured = isSecure && ConfigLoader.shared["secure"]
    return secured ? "https" : "http"
  }

  var body: Parameters? {
    return nil
  }

  // TODO: Add documentation
  var description: String {
    return String(describing: type(of: self))
  }

  func asURL(environment: Environment) throws -> URL {
    var urlComponents = URLComponents()

    urlComponents.path = path
    urlComponents.host = environment["host", ""]
    urlComponents.queryItems = queryParameters
    urlComponents.scheme = scheme

    return try urlComponents.asURL()
  }
}
