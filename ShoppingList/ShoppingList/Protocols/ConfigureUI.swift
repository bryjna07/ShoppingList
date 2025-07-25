//
//  ConfigureUI.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import Foundation

@objc protocol ConfigureUI: AnyObject {
    func configureHierarachy()
    func configureLayout()
    func configureView()
    @objc optional func configureUIWithData()
}
