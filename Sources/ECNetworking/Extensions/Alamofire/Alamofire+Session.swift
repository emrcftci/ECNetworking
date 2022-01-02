//
//  Alamofire+Session.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire

public extension Alamofire.Session {

  convenience init(httpAdditionalHeaders: HTTPHeaders) {

    var defaultHTTPHeaders = HTTPHeaders.default
    httpAdditionalHeaders.forEach { defaultHTTPHeaders.update($0) }

    defaultHTTPHeaders["Content-Type"] = "application/json"
    defaultHTTPHeaders["apnToken"] = UserLoader.shared.token
    defaultHTTPHeaders["deviceType"] = "1" // ?
    defaultHTTPHeaders["apikey"] = "6a648052e6b4dd0286347eadfe1bf01f"
    defaultHTTPHeaders["lang"] = "EN"

    let configuration = URLSessionConfiguration.af.default

    configuration.headers = defaultHTTPHeaders
    configuration.timeoutIntervalForRequest = 45
    configuration.timeoutIntervalForResource = 90
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.urlCache = .none

    self.init(configuration: configuration)
  }
}
