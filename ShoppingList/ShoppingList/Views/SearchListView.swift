//
//  SearchListView.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import SnapKit
import Then

final class SearchListView: UIView {
    
  
    
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

extension SearchListView: ConfigureUI {
    func configureHierarachy() {
   
    }
    
    func configureLayout() {
    
    }
    
    func configureView() {
        backgroundColor = .black
    }
    
    
}
