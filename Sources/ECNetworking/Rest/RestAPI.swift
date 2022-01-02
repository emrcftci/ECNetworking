//
//  RestAPI.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Alamofire

public class RestAPI: API {

  public typealias Executable = DataRequest

  public typealias Operation = HTTPTask

  public lazy var acceptableStatusCodes: [Int] = {
    var acceptableStatusCodes = [Int]()

    acceptableStatusCodes.append(contentsOf: 200...299)
    acceptableStatusCodes.append(contentsOf: 400...499)

//    acceptableStatusCodes.remove(NSHTTPURLResponseForbiddenStatusCode)
//    acceptableStatusCodes.remove(NSHTTPURLResponsePreconditionFailedStatusCode)
//    acceptableStatusCodes.remove(NSHTTPURLResponsePinCodeNeededStatusCode)
    return acceptableStatusCodes
  }()

  public func execute(operation: Operation) throws -> Executable {
    return try connector.request(
      operation.asURL(environment: environment),
      method: operation.method,
      parameters: operation.body,
      encoding: operation.encoding,
      headers: HTTPHeaders(operation.additionalHeaders)).validate(statusCode: acceptableStatusCodes)
  }

  public var host: String {
    return environment["host", ""]
  }

  public var port: String {
    return environment["port", ""]
  }

  private(set) public var connector: Session
  private(set) public var environment: Environment

  required public init(environment: Environment) {
    self.environment = environment
    self.connector = Session(httpAdditionalHeaders: HTTPHeaders())
  }

  public class func factory(config: ConfigLoader, allowsRetry: Bool = true) -> RestAPI {
    return .init(environment: config.environment)
  }
}
