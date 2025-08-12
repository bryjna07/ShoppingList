//
//  NetworkManager.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import Foundation
import Alamofire

enum CustomError: Error {
    case naverError(NaverError)
    case afError(AFError?)
}

//MARK: - Networking
final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    /// API 요청 메서드
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, CustomError>) -> Void) {
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret,
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<500)
            .responseData{ data in
                switch data.data {
                case .some(let data):
                    if let naverError = data.transformNaverError {
                        let errorCode = NaverErrorCode(rawValue: naverError.errorCode)
                        switch errorCode {
                        case .se01:
                            dump(naverError)
                        case .se02:
                            dump(naverError)
                        case .se03:
                            dump(naverError)
                        case .se04:
                            completion(.failure(CustomError.naverError(naverError)))
                        case .se05:
                            dump(naverError)
                        case .se06:
                            dump(naverError)
                        case .se99:
                            completion(.failure(CustomError.naverError(naverError)))
                        case .none:
                            dump(naverError)
                        }
                    } else if let value = try? JSONDecoder().decode(T.self, from: data) {
                        completion(.success(value))
                    }
                case .none:
                    completion(.failure(CustomError.afError(data.error)))
                }
            }
    }
    
    func makeURL(from endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return components.url
    }
}
