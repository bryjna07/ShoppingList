//
//  SearchListViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit

final class SearchListViewController: UIViewController {
    
    private let listView = SearchListView()
    
    private var itemData: ItemData?
    
    private var list: [Item] = []
    
    init(title: String, data: ItemData) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        itemData = data
        list = data.items
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.collectionView.delegate = self
        listView.collectionView.dataSource = self
        guard let itemData else { return }
        listView.resultCountLabel.text = "\(itemData.total)개의 검색 결과"
    }
}

///Mark: - CollectionView Protocols
extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listView.collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.id, for: indexPath) as? ItemCell else { return UICollectionViewCell() }
        cell.item = list[indexPath.row]
        return cell
    }
}
