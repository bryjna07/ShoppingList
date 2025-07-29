//
//  SearchListView.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import SnapKit
import Then

final class SearchListView: BaseView {
    
    ///Mark: - SearchListView Property
    let resultCountLabel = UILabel().then {
        $0.textColor = .systemGreen
        $0.font = .systemFont(ofSize: 14)
    }
    
    let sortViews = [SortButtonView(type: Sort.sim), SortButtonView(type: Sort.date), SortButtonView(type: Sort.asc), SortButtonView(type: Sort.dsc),]
    
    private lazy var buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.addArrangedSubview(sortViews[0])
        $0.addArrangedSubview(sortViews[1])
        $0.addArrangedSubview(sortViews[2])
        $0.addArrangedSubview(sortViews[3])
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        let width = (UIScreen.main.bounds.width - 48) / 2
        $0.itemSize = CGSize(width: width, height: width + 100) /// 높이 계산 필요
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.id)
        $0.backgroundColor = .black
    }
    
    private let secondLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 2
        let width = (UIScreen.main.bounds.width - 8) / 5
        $0.itemSize = CGSize(width: width, height: 100)
    }
    
    lazy var horizontalCollectionView = UICollectionView(frame: .zero, collectionViewLayout: secondLayout).then {
        $0.register(horizontalCell.self, forCellWithReuseIdentifier: horizontalCell.id)
        $0.backgroundColor = .black
    }
}

///Mark: - SearchListView AutoLayout
extension SearchListView {
    override func configureHierarachy() {
        [
            resultCountLabel,
            buttonStack,
            collectionView,
            horizontalCollectionView,
            activityIndicatorView,
        ].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        horizontalCollectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        resultCountLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.verticalEdges.equalTo(safeAreaLayoutGuide).inset(100)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
