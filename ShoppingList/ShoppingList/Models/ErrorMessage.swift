//
//  ErrorMessage.swift
//  ShoppingList
//
//  Created by YoungJin on 7/28/25.
//

import Foundation

struct ErrorMessage: Error, Decodable {
    let errorMessage: String
    let errorCode: String
}

enum NaverErrorCode: String {
    case se01 = "SE01"
    case se02 = "SE02"
    case se03 = "SE03"
    case se04 = "SE04"
    case se05 = "SE05"
    case se06 = "SE06"
    case se99 = "SE99"
}
