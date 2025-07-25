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
    
    /// 검색 API 요청 메서드
    func fetchSearchData<T: Codable>(searchTerm: String, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchTerm)&display=10"
        
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
                completion(.failure(error))
            }
        }
    }
}
