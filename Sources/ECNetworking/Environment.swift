//
//  Environment.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Foundation

public struct Environment {
  /// Name of the environment
  public let name: String

  /// Any context depending on where this environment is used.
  public let context: [String: Any]

  public init(_ name: String, context: [String: Any]) {
    self.name = name
    self.context = context
  }

  public subscript<E>(key: String, defaultValue: @escaping @autoclosure () -> E) -> E {
    return context[key, default: defaultValue()] as! E
  }
}
