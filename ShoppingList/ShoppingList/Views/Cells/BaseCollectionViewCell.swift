//
//  BaseCollectionViewCell.swift
//  ShoppingList
//
//  Created by YoungJin on 7/29/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarachy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseCollectionViewCell: ConfigureUI {
    
    func configureUIWithData() {
    }
    
    func configureHierarachy() {
    }
    
    func configureLayout() {
    }
    
    func configureView() {
        backgroundColor = .clear
    }
}
