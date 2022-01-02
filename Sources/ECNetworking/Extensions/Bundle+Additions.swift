//
//  Bundle+Additions.swift
//  Networking
//
//  Created by Emre Çiftçi on 22.12.2021.
//

import Foundation

public extension Bundle {

  var applicationName: String {
    return infoDictionaryValue(forKey: String(kCFBundleNameKey))
  }

  var versionNumber: String {
    return infoDictionaryValue(forKey: "CFBundleShortVersionString")
  }

  var buildNumber: String {
    return infoDictionaryValue(forKey: "CFBundleVersion")
  }

  var versionAndBuildNumber: String {
    return "\(versionNumber) (\(buildNumber))"
  }

  var accessGroup: String {
    let prefix: String = infoDictionaryValue(forKey: "AppIdentifierPrefix")
    return "\(prefix)\(bundleIdentifier!)"
  }

  func infoDictionaryValue<V>(forKey key: String) -> V {
    return object(forInfoDictionaryKey: key) as! V
  }

  func versionAndBuildNumber(separator: String = ".") -> String {
    return "\(versionNumber)\(separator)\(buildNumber)"
  }

  var urlScheme: String {
    let urlTypes: [[String: Any]] = infoDictionaryValue(forKey: "CFBundleURLTypes")
    if
      let urlType = urlTypes.first,
      let urlSchemes = urlType["CFBundleURLSchemes"] as? [String],
      let urlScheme = urlSchemes.first
    {
    return urlScheme
    }
    return ""
  }
}
