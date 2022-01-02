//
//  Alamofire+HTTPHeaders.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire

public extension Alamofire.HTTPHeaders {

  init(_ dictionary: [String: String]) {
    let headers = dictionary.map { (name, value) in
      Alamofire.HTTPHeader(name: name, value: value)
    }
    self.init(headers)
  }
}
