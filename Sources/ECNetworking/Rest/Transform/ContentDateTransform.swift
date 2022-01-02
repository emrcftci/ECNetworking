//
//  ContentDateTransform.swift
//  Networking
//
//  Created by Emre Çiftçi on 28.12.2021.
//

import Foundation
import ObjectMapper

public class ContentDateTransform: TransformType {

  public typealias Object = Date
  public typealias JSON = String

  private var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = .autoupdatingCurrent
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }

  public init() { }

  public func transformToJSON(_ value: Object?) -> JSON? {
    guard let value = value else { return nil }
    return formatter.string(from: value)
  }

  public func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else { return nil }
    return formatter.date(from: value)
  }
}
