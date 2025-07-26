//
//  NumberFormatter.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit

struct YJFormatter {
    static let shared = YJFormatter()
    private init() {}
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func formatInt(_ number: Int) -> String {
        let num = NSNumber(value: number)
        return formatter.string(from: num) ?? "\(number)"
    }
    
    func formatNumberSting(_ number: String) -> String {
        guard let numInt = Int(number) else { return number }
        let num = NSNumber(value: numInt)
        return formatter.string(from: num) ?? number
    }
}
