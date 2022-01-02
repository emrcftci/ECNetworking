//
//  SwiftyUserDefaults+Additions.swift
//  Networking
//
//  Created by Emre Çiftçi on 25.12.2021.
//

import SwiftyUserDefaults

// MARK: - Keys

public extension DefaultsKeys {

  // Login
  static let isLoggedIn = DefaultsKey<Bool>("isLoggedIn", defaultValue: false)
  static let outletNumber = DefaultsKey<String>("outletNumber", defaultValue: "")
  static let phone = DefaultsKey<String>("phone", defaultValue: "")

  // Forgot Password
  static let tempUserID = DefaultsKey<String>("tempUserID", defaultValue: "")
  static let tempResetToken = DefaultsKey<String>("tempResetToken", defaultValue: "")

  // Headers
  static let apnToken = DefaultsKey<String>("apnToken", defaultValue: "")
  static let sessionID = DefaultsKey<String>("sessionID", defaultValue: "")

  // Specials
  static let hasGuideShown = DefaultsKey<Bool>("hasGuideShown", defaultValue: false)
}
