//
//  Reader.swift
//  E-Commerce
//
//  Created by Emre Çiftçi on 28.03.2021.
//

import Foundation

public final class Reader {

  public static func json(bundle: Bundle, name: String) -> [String: Any]? {

    if let url = bundle.url(forResource: name, withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let dictionary = object as? [String: AnyObject] {
          return dictionary
        }
      }
      catch {
        print("Error!! Unable to parse  \(name).json")
      }
    }
    return .none
  }
}
