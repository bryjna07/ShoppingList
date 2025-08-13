//
//  Router.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//
//

import Foundation
import Alamofire

protocol Endpoint {
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameter: Parameters { get }
}

/// 여러개의 API를 사용한다면?
enum Router: Endpoint {
//    case naver(NaverAPI)
//    case Kakao(KaKaoAPI)
//}

//enum NaverAPI: Endpoint {
    
    case naverShopSearch(NaverShopSearchParameter)
    case KakaoShopSearch
    
    var method: HTTPMethod {
        switch self {
        case .naverShopSearch:
            return .get
        case .KakaoShopSearch:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .naverShopSearch:
            return [
                "X-Naver-Client-Id": APIKey.naverId,
                "X-Naver-Client-Secret": APIKey.naverSecret,
            ]
        case .KakaoShopSearch:
            return [
                "X-Naver-Client-Id": APIKey.naverId,
                "X-Naver-Client-Secret": APIKey.naverSecret,
            ]
        }
    }
    
    var scheme: String { return "https" }
    
    var host: String { return "openapi.naver.com" }
    
    var path: String {
        switch self {
        case .naverShopSearch:
            return "/v1/search/shop.json"
        case .KakaoShopSearch:
            return "/v1/search/shop.json"
        }
    }
    
    var endpint: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components.url
    }
    
    var parameter: Parameters {
        switch self {
        case .naverShopSearch(let parameter):
            return [
                "query": parameter.query,
                "display": parameter.display,
                "sort": parameter.sort,
                "start": parameter.start,
            ]
        case .KakaoShopSearch:
            return [
                "query": "",
                "display": "",
            ]
        }
    }
}

struct NaverShopSearchParameter {
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
