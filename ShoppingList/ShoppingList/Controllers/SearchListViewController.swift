//
//  SearchListViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit

final class SearchListViewController: UIViewController {
    
    let listView = SearchListView()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
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
    }
}

///Mark: - CollectionView Protocols
extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listView.collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.id, for: indexPath) as? ItemCell else { return UICollectionViewCell() }
        return cell
    }
}
