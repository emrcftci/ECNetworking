//
//  Alamofire+NetworkActivityLogger.swift
//  Created by Konstantin Kabanov on 21.06.2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Konstantin Kabanov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Alamofire
import Foundation

// swiftlint:disable cyclomatic_complexity
public final class AlamofireNetworkActivityLogger {

  public static let shared = AlamofireNetworkActivityLogger()

  public enum Level {
    case off
    case debug
    case info
    case warn
    case error
    case fatal
  }

  public var level: Level
  public var filterPredicate: NSPredicate?

  private var operationQueue = OperationQueue(operationCount: 1)

  private init() {
    level = .info
  }

  deinit {
    operationQueue.cancelAllOperations()
    stopLogging()
  }

  public func startLogging(config: ConfigLoader) {
    switch config.version {
    case .development, .qa, .preprod:
      level = .debug
      startLogging()

    case .production:
      level = .off
    }
  }

  private func startLogging() {
    stopLogging()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AlamofireNetworkActivityLogger.requestDidStart(notification:)),
      name: Request.didResumeNotification,
      object: .none
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AlamofireNetworkActivityLogger.requestDidFinish(notification:)),
      name: Request.didFinishNotification,
      object: .none
    )
  }

  public func stopLogging() {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Private - Notifications

  @objc private func requestDidStart(notification: Notification) {
    operationQueue.addOperation { [weak self] in
      guard let self = self else { return }

      guard let dataRequest = notification.request as? DataRequest,
        let task = dataRequest.task,
        let request = task.originalRequest,
        let httpMethod = request.httpMethod,
        let requestURL = request.url

        else { return }

      if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
        return
      }

      switch self.level {
      case .debug:
        self.logDivider()
        print("\(httpMethod) '\(requestURL.absoluteString)':")

      case .info:
        self.logDivider()
        print("\(httpMethod) '\(requestURL.absoluteString)'")

      default:
        return
      }
    }
  }

  @objc private func requestDidFinish(notification: Notification) {
    operationQueue.addOperation { [weak self] in
      guard let self = self else { return }

      guard let dataRequest = notification.request as? DataRequest,
        let task = dataRequest.task,
        let metrics = dataRequest.metrics,
        let request = task.originalRequest,
        let httpMethod = request.httpMethod,
        let requestURL = request.url

        else { return }

      if let filterPredicate = self.filterPredicate, filterPredicate.evaluate(with: request) {
        return
      }
      let elapsedTime = metrics.taskInterval.duration

      if let error = task.error {
        switch self.level {
        case .debug, .info, .warn, .error:
          self.logDivider()

          print("[Error] \(httpMethod) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:")
          print(error)

        default:
          return
        }
      }
      else {
        guard let response = task.response as? HTTPURLResponse
          else { return }

        switch self.level {
        case .debug:
          self.logDivider()

          print(
            "\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]:"
          )

          self.logHeaders(headers: response.allHeaderFields)

          guard let data = dataRequest.data else { break }

          do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

            if let prettyString = String(data: prettyData, encoding: .utf8) {
              print(prettyString)
            }
          }
          catch {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
              print(string)
            }
          }

        case .info:
          self.logDivider()

          print(
            "\(String(response.statusCode)) '\(requestURL.absoluteString)' [\(String(format: "%.04f", elapsedTime)) s]"
          )

        default:
          return
        }
      }
    }
  }

  private func logDivider() {
    print("---------------------")
  }

  private func logHeaders(headers: [AnyHashable: Any]) {
    print("Headers: [")
    for (key, value) in headers {
      print("  \(key): \(value)")
    }
    print("]")
  }
}
// swiftlint:enable cyclomatic_complexity
