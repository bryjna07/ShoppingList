//
//  Constants.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import Foundation

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
