//
//  Service.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import PromiseKit

public protocol Service: AnyObject {

  associatedtype Backend: API

  init(backend: Backend)

  func execute<R: APIResponse>(task: Backend.Operation) -> Promise<R>
}
