//
//  RestService.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire
import PromiseKit

public typealias Promise = PromiseKit.Promise
public typealias Guarantee = PromiseKit.Guarantee
public typealias ProgressHandler = Alamofire.Request.ProgressHandler

public final class RestService: Service {

  public typealias Backend = RestAPI

  public var cancelsPreviousOperations: Bool

  private(set) public var backend: RestAPI
  private var operations: [String: DataRequest]

  public required init(backend: Backend) {
    self.backend = backend
    self.operations = [String: DataRequest]()
    self.cancelsPreviousOperations = true
  }

  public func execute<R: APIResponse>(task: Backend.Operation) -> Promise<R> {
    return
      firstly {
        [weak self] () -> Guarantee<AFDataResponse<R>> in

        guard let self = self else { throw PMKError.cancelled }

        safeSync {
          if self.cancelsPreviousOperations {
            self.operations[task.description]?.cancel()
          }
        }

        let operation = try backend.execute(operation: task)
        safeSync {
          self.operations[task.description] = operation
        }

        return operation.responseObject()
      }
      .then { response -> Promise<R> in
        try response.value?.throwErrorIfFailure()

        return Promise { resolver in
          resolver.resolve(response.value, response.error)
        }
      }
  }

  public func cancelAll() {
    operations.cancelAll()
  }

  deinit { cancelAll() }
}

// MARK: - Dictionary + DataRequest

private extension Dictionary where Value == DataRequest {

  mutating func cancelAll() {
    values.forEach { $0.cancel() }
    removeAll(keepingCapacity: false)
  }
}
