//
//  APIResponseLoader.swift
//  E-Commerce
//
//  Created by Emre Çiftçi on 28.03.2021.
//

import ObjectMapper

public struct APIResponseLoader {

  public static func loadObject<T: BaseMappable>(from file: String, bundle: Bundle = .main) -> RestObjectResponse<T>! {
    let JSON: [String: Any] = Reader.json(bundle: bundle, name: file)!
    return Mapper<RestObjectResponse<T>>(context: nil, shouldIncludeNilValues: true).map(JSONObject: JSON)
  }

  public static func loadObjects<T: BaseMappable>(from file: String, bundle: Bundle = .main) -> RestArrayResponse<T>! {
    let JSON: [String: Any] = Reader.json(bundle: bundle, name: file)!
    return Mapper<RestArrayResponse<T>>(context: nil, shouldIncludeNilValues: true).map(JSONObject: JSON)
  }
}
