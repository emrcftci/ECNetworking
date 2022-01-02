//
//  OperationQueue+Additions.swift
//  Networking
//
//  Created by Emre Çiftçi on 22.12.2021.
//

import Foundation

public extension OperationQueue {

  convenience init(operationCount: Int) {
    self.init()
    maxConcurrentOperationCount = operationCount
  }
}
