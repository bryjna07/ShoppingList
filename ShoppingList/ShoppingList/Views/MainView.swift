//
//  MainView.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import SnapKit
import Then

final class MainView: BaseView {
    
    ///Mark: - MainView Property
    let searchBar = UISearchBar().then {
        $0.placeholder = "브랜드, 상품, 프로필, 태그 등"
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: $0.searchTextField.placeholder ?? "", attributes: [.foregroundColor : UIColor.systemGray3]) // 플레이스홀더 색상
        $0.barTintColor = .black // 서치바 배경색
        $0.searchTextField.backgroundColor = .darkGray // 서치 텍필 색상
        $0.searchTextField.leftView?.tintColor = .systemGray3 // 서치 아이콘 색상
        $0.tintColor = .white // 커서 색상
        $0.searchTextField.font = .systemFont(ofSize: 18)
        $0.searchTextField.textColor = .white // 입력 색상
    }
}

///Mark: - MainView AutoLayout
extension MainView {
    override func configureHierarachy() {
        [
            searchBar,
            activityIndicatorView
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
           }
    }
    
    override func configureView() {
        super.configureView()
    } 
}
