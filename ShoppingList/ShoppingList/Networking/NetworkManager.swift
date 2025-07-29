//
//  NetworkManager.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import Foundation
import Alamofire

//MARK: - Networking
final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    /// API 요청 메서드
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void, naverError: @escaping (ErrorMessage) -> Void) {
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret,
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let errorResponse = response.data,
                       let errorData = try? JSONDecoder().decode(ErrorMessage.self, from: errorResponse), let customError = NaverErrorCode(rawValue: errorData.errorCode) {
                        switch customError {
                        case .se01:
                            dump(errorData)
                        case .se02:
                            dump(errorData)
                        case .se03:
                            dump(errorData)
                        case .se04:
                            naverError(errorData)
                        case .se05:
                            dump(errorData)
                        case .se06:
                            dump(errorData)
                        case .se99:
                            naverError(errorData)
                        }
                    } else {
                        completion(.failure(error))
                    }
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
