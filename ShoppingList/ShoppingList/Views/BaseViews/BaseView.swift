//
//  BaseView.swift
//  ShoppingList
//
//  Created by YoungJin on 7/29/25.
//

import UIKit
import Then
import SnapKit

class BaseView: UIView {
    
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
        .then {
            $0.hidesWhenStopped = true
            $0.stopAnimating()
            $0.color = .white
        }
    
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

extension BaseView: ConfigureUI {
    func configureHierarachy() { }
    
    func configureLayout() { }
    
    func configureView() {
        backgroundColor = .black
    }
}
