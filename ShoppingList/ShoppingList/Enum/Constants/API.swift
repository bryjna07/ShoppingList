//
//  API.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

enum API {
    case naver(NaverAPI)
    // baseURL, Query, parameter 등 구분하여 정리 + 정렬기능
    /*
     검색 결과 정렬 방법
     - sim: 정확도순으로 내림차순 정렬(기본값)
     - date: 날짜순으로 내림차순 정렬
     - asc: 가격순으로 오름차순 정렬
     - dsc: 가격순으로 내림차순 정렬
     */
}

enum NaverAPI: Endpoint {
    
    case shopSearch(ShopSearchParameter)
    
    var scheme: String { return "https" }
    
    var host: String { return "openapi.naver.com" }
    
    var path: String { return "/v1/search/shop.json" }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .shopSearch(let parameter):
            let items: [URLQueryItem] = [
                URLQueryItem(name: "query", value: parameter.query),
                URLQueryItem(name: "display", value: "\(parameter.display)"),
                URLQueryItem(name: "sort", value: "\(parameter.sort)"),
                URLQueryItem(name: "start", value: "\(parameter.start)"),
            ]
            return items
        }
    }
}

struct ShopSearchParameter {
    var query: String
    var display: Int = 30
    var sort: String = "sim"
    var start: Int = 1
}

enum APIKey {

    static let naverId: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "Id") as? String else {
            fatalError("API 키가 설정되지 않았습니다.")
        }
        return key
    }()
    
    static let naverSecret: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "Secret") as? String else {
            fatalError("API 키가 설정되지 않았습니다.")
        }
        return key
    }()
}
