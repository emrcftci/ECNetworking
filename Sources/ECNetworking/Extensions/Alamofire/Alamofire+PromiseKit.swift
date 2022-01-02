//
//  Alamofire+PromiseKit.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire
import Foundation
import ObjectMapper
import PromiseKit

public extension Alamofire.DataRequest {

  func responseObject<T: BaseMappable>(
    queue: DispatchQueue = .main,
    keyPath: String? = .none,
    mapToObject object: T? = .none,
    context: MapContext? = .none) -> Guarantee<AFDataResponse<T>>
  {
    return Guarantee { resolver in
      responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context) {
        resolver($0)
      }
    }
  }

  func responseArray<T: BaseMappable>(
    queue: DispatchQueue = .main,
    keyPath: String? = .none,
    context: MapContext? = .none) -> Guarantee<AFDataResponse<[T]>>
  {
    return Guarantee { resolver in
      responseArray(queue: queue, keyPath: keyPath, context: context) {
        resolver($0)
      }
    }
  }
}
