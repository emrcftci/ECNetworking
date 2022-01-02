//
//  Thenable+PromiseKit.swift
//  E-Commerce
//
//  Created by Rufat Mirza on 9.04.2021.
//  Copyright © 2021 CCI. All rights reserved.
//

import Dispatch
import Foundation
import PromiseKit

public extension PromiseKit.Thenable {

  func ensureMap<U>(_ transform: @escaping (Self.T?) -> U) -> PromiseKit.Guarantee<U> {
    let (guarantee, resolver) = PromiseKit.Guarantee<U>.pending()

    pipe { result in
      resolver(transform(result.value))
    }
    return guarantee
  }

  func `switch`(to queue: DispatchQueue) -> PromiseKit.Promise<Self.T> {
    return get(on: queue) { _ in }
  }

  func finalize(body: @escaping (Self.T) throws -> Void) {
    done(body).cauterize()
  }

  func pipe(to block: @escaping (PromiseKit.Result<Self.T>) -> Void) -> Self {
    pipe(to: block)
    return self
  }

  @discardableResult func error(action: @escaping (Error) -> Void) -> Self {
    return pipe {
      guard let error = $0.error, !error.connectionCancelled,
        !error.notConnectedToInternet, !error.receivedAuthenticationFailed else { return }

      action(error.underlyingError)
    }
  }

  @discardableResult func grouped(with group: DispatchGroup) -> Self {
    group.enter()
    pipe { [weak group] _ in
      group?.leave()
    }
    return self
  }

  @discardableResult func grouped(with group: DispatchGroup, delay seconds: Double) -> Self {
    group.enter()
    pipe { [weak group] _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        group?.leave()
      }
    }
    return self
  }
}

public func when<U: Thenable, V: Thenable>(resolved first: U, _ second: V) -> Guarantee<(U.T?, V.T?)> {
  return PromiseKit.when(resolved: first.asVoid(), second.asVoid()).ensureMap { _ in
    (first.value, second.value)
  }
}

public func when<U: Thenable, V: Thenable, Z: Thenable>(
  resolved first: U, _ second: V, _ third: Z) -> Guarantee<(U.T?, V.T?, Z.T?)>
{
  return PromiseKit.when(resolved: first.asVoid(), second.asVoid(), third.asVoid()).ensureMap { _ in
    (first.value, second.value, third.value)
  }
}

// MARK: - Error

fileprivate extension Error {

  var underlyingError: Error {
    return (asAFError?.underlyingError) ?? self
  }

  var notConnectedToInternet: Bool {
    return code == NSURLErrorNotConnectedToInternet
  }

  var connectionCancelled: Bool {
    if let error = asAFError {
      return error.isExplicitlyCancelledError || error.isSessionDeinitializedError
    }
    return code == NSURLErrorCancelled
  }

  var receivedAuthenticationFailed: Bool {
    guard let error = asAFError else { return false }

    return error.receivedAuthenticationFailed
  }
}
