//
//  Cache.swift
//  Networking
//
//  Created by Emre Çiftçi on 22.12.2021.
//

import Foundation
import UIKit

open class Cache<Key: Hashable, Value>: NSObject {

  private let cache = NSCache<KeyHolder<Key>, ValueHolder<Value>>()

  public override init() {
    super.init()
    NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) {
      [unowned self] _ in
      self.cache.removeAllObjects()
    }
  }

  public subscript(_ key: Key) -> Value? {
    get {
      return cache.object(forKey: KeyHolder(key))?.value
    }
    set {
      if let newValue = newValue {
        cache.setObject(ValueHolder(newValue), forKey: KeyHolder(key))
      }
      else {
        cache.removeObject(forKey: KeyHolder(key))
      }
    }
  }

  public func removeAll() {
    cache.removeAllObjects()
  }
}

// MARK: - Private API

private extension Cache {

  final class KeyHolder<T: Hashable>: NSObject {

    public let key: T

    public override var hash: Int {
      return key.hashValue
    }

    public init(_ key: T) {
      self.key = key
    }

    public override func isEqual(_ object: Any?) -> Bool {
      guard let object = object as? KeyHolder<T> else { return false }
      return object.key == key
    }
  }

  final class ValueHolder<T> {

    public let value: T

    public init(_ value: T) {
      self.value = value
    }
  }
}
