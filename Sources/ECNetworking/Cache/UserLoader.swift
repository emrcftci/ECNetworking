//
//  UserLoader.swift
//  Networking
//
//  Created by Emre Çiftçi on 22.12.2021.
//

import Foundation
import SwiftyUserDefaults

public final class UserLoader {

  public static let shared = UserLoader()

  private let defaults: UserDefaults = Defaults

  public var token: String {
    get { return defaults[.apnToken] }
    set { defaults[.apnToken] = newValue }
  }

  public var sessionID: String {
    get { return defaults[.sessionID] }
    set { defaults[.sessionID] = newValue }
  }

  public var isLoggedIn: Bool {
    get { return defaults[.isLoggedIn] }
    set {
      defaults[.isLoggedIn] = newValue

      if !newValue {
         removeAll()
      }
    }
  }

  public var phone: String {
    get { return defaults[.phone] }
    set { defaults[.phone] = newValue }
  }

  public var outletNumber: String {
    get { return defaults[.outletNumber] }
    set { defaults[.outletNumber] = newValue }
  }

  public var tempUserID: String {
    get { return defaults[.tempUserID] }
    set { defaults[.tempUserID] = newValue }
  }

  public var tempResetToken: String {
    get { return defaults[.tempResetToken] }
    set { defaults[.tempResetToken] = newValue }
  }

  public var hasGuideShown: Bool {
    get { return defaults[.hasGuideShown] }
    set { defaults[.hasGuideShown] = newValue }
  }

  // MARK: - Private Helpers

  private func removeAll() {
    defaults.removeAll()
  }
}
