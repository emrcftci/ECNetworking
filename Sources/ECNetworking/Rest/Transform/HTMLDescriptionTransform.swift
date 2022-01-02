//
//  HTMLDescriptionTransform.swift
//  Networking
//
//  Created by Emre Çiftçi on 29.12.2021.
//

import ObjectMapper

public class HTMLDescriptionTransform: TransformType {

  public typealias Object = NSAttributedString
  public typealias JSON = String

  public init() { }

  public func transformToJSON(_ value: Object?) -> JSON? {
    guard let value = value else { return nil }
    return value.string
  }

  public func transformFromJSON(_ value: Any?) -> Object? {
    guard let value = value as? String else { return nil }
    return value.attributedHMTLString
  }
}

// MARK: - HTML

private extension String {

  var attributedHMTLString: NSAttributedString? {
    let format = "<span style=\"font-family: '-apple-system', '.SFUI-Regular'))'; font-size: 18\">%@</span>"
    let modifiedText = String(format: format, self)

    guard let data = modifiedText.data(using: .utf8) else { return nil }

    do {
      return try NSAttributedString(data: data,
                                    options: [
                                      .documentType: NSAttributedString.DocumentType.html,
                                      .characterEncoding: String.Encoding.utf8.rawValue
                                    ],
                                    documentAttributes: nil)
    }
    catch {
      return nil
    }
  }
}
