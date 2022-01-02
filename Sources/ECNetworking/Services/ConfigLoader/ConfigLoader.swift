//
//  ConfigLoader.swift
//  E-Commerce
//
//  Created by Emre Çiftçi on 8.02.2021.
//

import Foundation

public final class ConfigLoader {

  public enum Version: String, CustomStringConvertible {
    case development = "Development"
    case qa = "QA"
    case preprod = "PREPROD"
    case production = "Production"

    public var description: String {
      rawValue
    }

    public var information: String {
      "\(description) | v\(Bundle.main.versionNumber) | build: \(Bundle.main.buildNumber)"
    }
  }

  private typealias ConfigType = [String: Any]

  public static let shared = ConfigLoader()

  private lazy var config: ConfigType = readConfig()

  private func readConfig() -> ConfigType {
    Bundle.main.infoDictionaryValue(forKey: "Config")
  }

  public var version: Version {
    Version(rawValue: self["environment"])!
  }

  public var environment: Environment {
    Environment(version.rawValue, context: config)
  }

  public subscript(key: String) -> Int {
    Int(self[key]) ?? NSNotFound
  }

  public subscript(key: String) -> Bool {
    if let value = config[key] as? Bool {
      return value
    }
    else {
      return self[key].uppercased() == "YES"
    }
  }

  public subscript<E>(key: String, default defaultValue: @escaping @autoclosure () -> E) -> E {
    config[key, default: defaultValue()] as! E
  }

  public subscript(key: String) -> String {
    let value: String = self[key, default: ""]
    guard value.isEmpty else { return value }

    if let contentContext = config["Static Content IDs"] as? ConfigType,
       let contentValue = contentContext[key] as? String
    {
    return contentValue
    }
    else {
      assertionFailure("The config could not be found")
    }
    return value
  }
}

// MARK: - ConfigLoader.Version

public extension ConfigLoader.Version {

  func configFile(inBundle bundle: Bundle) -> String {
    return bundle.path(forResource: "GoogleService-Info-\(description)", ofType: "plist") ?? ""
  }
}
