//
//  Dispatch+Additions.swift
//  Networking
//
//  Created by Emre Çiftçi on 22.12.2021.
//

import Dispatch
import Foundation

public func after(on queue: DispatchQueue = .main, seconds: Double, execute: @escaping () -> Void) {
  let time: DispatchTime = .now() + seconds
  queue.asyncAfter(deadline: time, execute: execute)
}

public func after(on queue: DispatchQueue = .main, seconds: Double, execute: DispatchWorkItem) {
  let time: DispatchTime = .now() + seconds
  queue.asyncAfter(deadline: time, execute: execute)
}

public func async(on queue: DispatchQueue = .main, execute: @escaping () -> Void) {
  queue.async(execute: execute)
}

public extension DispatchQueue {
  static let userInitiated: DispatchQueue = .global(qos: .userInitiated)
}

@discardableResult
public func safeSync<T>(execute: (() -> T)) -> T {
  if Thread.isMainThread {
    return execute()
  }
  else {
    return DispatchQueue.main.sync(execute: execute)
  }
}
