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
    func fetchData<T: Decodable>(api: Router, completion: @escaping (Result<T, CustomError>) -> Void) {
        
        guard let url = api.endpint else { return }
        
        AF.request(url,
                   method: .get,
                   parameters: api.parameter,
                   headers: api.headers
        )
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
}
