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
}

struct Item: Codable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
}
