//
//  API.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Foundation

public protocol API {

  associatedtype Executable: Cancellable
  associatedtype Operation

  init(environment: Environment)
  func execute(operation: Operation) throws -> Executable
}
