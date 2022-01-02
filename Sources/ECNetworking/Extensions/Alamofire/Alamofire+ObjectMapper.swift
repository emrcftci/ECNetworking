//
//  Alamofire+ObjectMapper.swift
//  Created by Tristan Himmelman on 30.04.2015.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2015 Tristan Himmelman
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Alamofire
import ObjectMapper

public extension Alamofire.DataRequest {

  enum ErrorCode: Int {
    case noData = 1
    case dataSerializationFailed = 2
  }

  private static func processResponse(
    request: URLRequest?, response: HTTPURLResponse?, data: Data?, keyPath: String?) -> Any?
  {
    let serializer = JSONResponseSerializer(options: .allowFragments)
    if let result = try? serializer.serialize(request: request, response: response, data: data, error: .none) {

      let JSON: Any?
      if let keyPath = keyPath, keyPath.isEmpty == false {
        JSON = (result as AnyObject?)?.value(forKeyPath: keyPath)
      }
      else {
        JSON = result
      }
      return JSON
    }
    return .none
  }

  private static func newError(_ code: ErrorCode, failureReason: String) -> NSError {
    let errorDomain = "com.alamofire.objectmapper.error"

    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
    let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)

    return returnError
  }

  private static func checkResponseForError(
    request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Error?
  {
    if let error = error {
      return error
    }
    else if data == nil {
      return newError(.noData, failureReason: "Data could not be serialized. Input data was nil.")
    }
    else {
      return .none
    }
  }

  static func ObjectMapperSerializer<T: BaseMappable>(
    _ keyPath: String?, mapToObject object: T? = .none, context: MapContext? = .none) -> MappableResponseSerializer<T>
  {
    return MappableResponseSerializer(keyPath, mapToObject: object, context: context) {
      request, response, data, error in

      let JSONObject = processResponse(request: request, response: response, data: data, keyPath: keyPath)

      if let object = object {
        _ = Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: JSONObject, toObject: object)
        return object
      }
      else if let object = Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: JSONObject) {
        return object
      }
      let failureReason = "ObjectMapper failed to serialize response."

      throw AFError.responseSerializationFailed(reason:
        .decodingFailed(error: newError(.dataSerializationFailed, failureReason: failureReason))
      )
    }
  }

  static func ObjectMapperImmutableSerializer<T: ImmutableMappable>(
    _ keyPath: String?, context: MapContext? = .none) -> MappableResponseSerializer<T>
  {
    return MappableResponseSerializer(keyPath, context: context) { request, response, data, error in

      let JSONObject = processResponse(request: request, response: response, data: data, keyPath: keyPath)
      if
        let JSONObject = JSONObject,
        let object = (try? Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: JSONObject) as T)
      {
        return object
      }
      else {
        let failureReason = "ObjectMapper failed to serialize response."
        throw AFError.responseSerializationFailed(
          reason: .decodingFailed(error: newError(.dataSerializationFailed, failureReason: failureReason))
        )
      }
    }
  }

  @discardableResult func responseObject<T: BaseMappable>(
    queue: DispatchQueue = .main,
    keyPath: String? = .none,
    mapToObject object: T? = .none,
    context: MapContext? = .none,
    completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self
  {
    return response(
      queue: queue,
      responseSerializer: DataRequest.ObjectMapperSerializer(keyPath, mapToObject: object, context: context),
      completionHandler: completionHandler
    )
  }

  @discardableResult func responseObject<T: ImmutableMappable>(
    queue: DispatchQueue = .main,
    keyPath: String? = .none,
    mapToObject object: T? = .none,
    context: MapContext? = .none,
    completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self
  {
    return response(
      queue: queue,
      responseSerializer: DataRequest.ObjectMapperImmutableSerializer(keyPath, context: context),
      completionHandler: completionHandler
    )
  }

  static func ObjectMapperArraySerializer<T: BaseMappable>(
    _ keyPath: String?, context: MapContext? = .none) -> MappableArrayResponseSerializer<T>
  {
    return MappableArrayResponseSerializer(keyPath, context: context, serializeCallback: {
      request, response, data, error in

      let JSONObject = processResponse(request: request, response: response, data: data, keyPath: keyPath)

      if let object = Mapper<T>(context: context, shouldIncludeNilValues: false).mapArray(JSONObject: JSONObject) {
        return object
      }

      let failureReason = "ObjectMapper failed to serialize response."
      throw AFError.responseSerializationFailed(reason:
        .decodingFailed(error: newError(.dataSerializationFailed, failureReason: failureReason))
      )
    })
  }

  static func ObjectMapperImmutableArraySerializer<T: ImmutableMappable>(
    _ keyPath: String?, context: MapContext? = .none) -> MappableArrayResponseSerializer<T>
  {
    return MappableArrayResponseSerializer(keyPath, context: context, serializeCallback: {
      request, response, data, error in
      if
        let JSON = processResponse(request: request, response: response, data: data, keyPath: keyPath),
        let object = try? Mapper<T>(context: context, shouldIncludeNilValues: false).mapArray(JSONObject: JSON) as [T]
      {
        return object
      }

      let failureReason = "ObjectMapper failed to serialize response."
      throw AFError.responseSerializationFailed(reason:
        .decodingFailed(error: newError(.dataSerializationFailed, failureReason: failureReason))
      )
    })
  }

  @discardableResult func responseArray<T: BaseMappable>(
    queue: DispatchQueue = .main,
    keyPath: String? = .none,
    context: MapContext? = .none,
    completionHandler: @escaping (AFDataResponse<[T]>) -> Void) -> Self
  {
    return response(
      queue: queue,
      responseSerializer: DataRequest.ObjectMapperArraySerializer(keyPath, context: context),
      completionHandler: completionHandler
    )
  }

  @discardableResult func responseArray<T: ImmutableMappable>(
    queue: DispatchQueue = .main,
    keyPath: String? = .none,
    context: MapContext? = .none,
    completionHandler: @escaping (AFDataResponse<[T]>) -> Void) -> Self
  {
    return response(
      queue: queue,
      responseSerializer: DataRequest.ObjectMapperImmutableArraySerializer(keyPath, context: context),
      completionHandler: completionHandler
    )
  }
}

// MARK: - MappableResponseSerializer

public final class MappableResponseSerializer<T: BaseMappable>: ResponseSerializer {

  public let decoder: DataDecoder = JSONDecoder()
  public let emptyResponseCodes: Set<Int>
  public let emptyRequestMethods: Set<HTTPMethod>

  public let keyPath: String?
  public let context: MapContext?
  public let object: T?

  public let serializeCallback: (URLRequest?, HTTPURLResponse?, Data?, Error?) throws -> T

  public init(
    _ keyPath: String?,
    mapToObject object: T? = .none,
    context: MapContext? = .none,
    emptyResponseCodes: Set<Int> = MappableResponseSerializer.defaultEmptyResponseCodes,
    emptyRequestMethods: Set<HTTPMethod> = MappableResponseSerializer.defaultEmptyRequestMethods,
    serializeCallback: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) throws -> T)
  {
    self.emptyResponseCodes = emptyResponseCodes
    self.emptyRequestMethods = emptyRequestMethods

    self.keyPath = keyPath
    self.context = context
    self.object = object
    self.serializeCallback = serializeCallback
  }

  public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
    guard error == nil else { throw error! }

    guard let data = data, !data.isEmpty else {
      guard emptyResponseAllowed(forRequest: request, response: response) else {
        throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
      }

      guard let emptyValue = Empty.value as? T else {
        throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "\(T.self)"))
      }

      return emptyValue
    }
    return try serializeCallback(request, response, data, error)
  }
}

// MARK: - MappableArrayResponseSerializer

public final class MappableArrayResponseSerializer<T: BaseMappable>: ResponseSerializer {

  public let decoder: DataDecoder = JSONDecoder()
  public let emptyResponseCodes: Set<Int>
  public let emptyRequestMethods: Set<HTTPMethod>

  public let keyPath: String?
  public let context: MapContext?

  public let serializeCallback: (URLRequest?, HTTPURLResponse?, Data?, Error?) throws -> [T]

  public init(
    _ keyPath: String?,
    context: MapContext? = .none,
    serializeCallback: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) throws -> [T],
    emptyResponseCodes: Set<Int> = MappableArrayResponseSerializer.defaultEmptyResponseCodes,
    emptyRequestMethods: Set<HTTPMethod> = MappableArrayResponseSerializer.defaultEmptyRequestMethods)
  {
    self.emptyResponseCodes = emptyResponseCodes
    self.emptyRequestMethods = emptyRequestMethods

    self.keyPath = keyPath
    self.context = context
    self.serializeCallback = serializeCallback
  }

  public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> [T] {
    guard error == nil else { throw error! }

    guard let data = data, !data.isEmpty else {
      guard emptyResponseAllowed(forRequest: request, response: response) else {
        throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
      }
      guard let emptyValue = Empty.value as? [T] else {
        throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "\(T.self)"))
      }
      return emptyValue
    }
    return try serializeCallback(request, response, data, error)
  }
}
