//
//  Result+PromiseKit.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import PromiseKit

public extension PromiseKit.Result {

  var isRejected: Bool {
    return !isFulfilled
  }

  var value: T? {
    switch self {
    case .fulfilled(let value):
      return value
    default:
      return nil
    }
  }

  var error: Error? {
    switch self {
    case .rejected(let error):
      return error
    default:
      return nil
    }
  }
}

// MARK: - Promiseable

public protocol Promiseable {}

extension Array: Promiseable {}

public extension Promiseable {

  func fulfilled() -> PromiseKit.Promise<Self> {
    return PromiseKit.Promise { $0.fulfill(self) }
  }

  func guaranteed() -> PromiseKit.Guarantee<Self> {
    return PromiseKit.Guarantee { $0(self) }
  }

  func rejected(_ error: Error) -> PromiseKit.Promise<Self> {
    return PromiseKit.Promise { $0.reject(error) }
  }
}

public extension Promiseable where Self: Error {

  func rejected<T>() -> PromiseKit.Promise<T> {
    return PromiseKit.Promise { $0.reject(self) }
  }
}
