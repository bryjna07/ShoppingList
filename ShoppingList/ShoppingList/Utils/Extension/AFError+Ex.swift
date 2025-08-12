//
//  AFError+Ex.swift
//  ShoppingList
//
//  Created by YoungJin on 7/30/25.
//

import Alamofire
import Foundation

extension Data {
    var transformNaverError: NaverError? {
        let naverError = try? JSONDecoder().decode(NaverError.self, from: self)
        return naverError
    }
}
