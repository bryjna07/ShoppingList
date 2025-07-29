//
//  BlankView.swift
//  ShoppingList
//
//  Created by YoungJin on 7/29/25.
//

import UIKit
import SnapKit
import Then

final class BlankView: BaseView {
    
    private let label = UILabel().then {
        $0.text = "네트워크 연결이 필요합니다"
        $0.font = .systemFont(ofSize: 30, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .center
    }
}

extension BlankView {
    override func configureHierarachy() {
        addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
