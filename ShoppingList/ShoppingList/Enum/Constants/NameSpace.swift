//
//  NameSpace.swift
//  ShoppingList
//
//  Created by YoungJin on 7/28/25.
//

import Foundation

enum Sort: String {
    case sim
    case date
    case dsc
    case asc
    
    var title: String {
        switch self {
        case .sim:
            return "정확도"
        case .date:
            return "날짜순"
        case .dsc:
            return "가격높은순"
        case .asc:
            return "가격낮은순"
        }
    }
}
