//
//  SortButton.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import SnapKit
import Then

final class SortButtonView: UIView {
    
    let button = UIButton(type: .system).then {
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.black, for: .selected)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        button.setTitle(title, for: .normal)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(36)
        }
        
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}
