//
//  ItemData.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import Foundation

struct ItemData: Codable {
    let total: Int
    let items: [Item]
    
    var totalString: String {
        return "\(YJFormatter.shared.formatInt(total))개의 검색 결과"
    }
}

struct Item: Codable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
    
    var titleForUI: String {
        title.replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
    }
    
    var price: String {
        return "\(YJFormatter.shared.formatNumberSting(lprice))원"
    }
}
