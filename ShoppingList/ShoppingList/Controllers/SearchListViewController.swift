//
//  SearchListViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import Alamofire

final class SearchListViewController: UIViewController {
    
    private let listView = SearchListView()
    
    private var itemData: ItemData? {
        didSet {
            guard let itemData else { return }
            list = itemData.items
            listView.collectionView.reloadData()
        }
    }
    
    private let numberFormatter = YJFormatter.shared
    
    private let networkManager = NetworkManager.shared
    
    private var list: [Item] = []
    
    var urlString = ""
    
    init(title: String, data: ItemData, urlString: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        itemData = data
        list = data.items
        self.urlString = urlString
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
        listView.resultCountLabel.text = itemData.totalString
        buttonActionSetup()
    }
    
    func buttonActionSetup() {
        listView.sortViews[0].button.addTarget(self, action: #selector(sortSimTapped), for: .touchUpInside)
        listView.sortViews[1].button.addTarget(self, action: #selector(sortDateTapped), for: .touchUpInside)
        listView.sortViews[2].button.addTarget(self, action: #selector(sortDscTapped), for: .touchUpInside)
        listView.sortViews[3].button.addTarget(self, action: #selector(sortAscTapped), for: .touchUpInside)
    }
    
    @objc func sortSimTapped() {
        guard let title else { return }
        let parmeter = ShopSearchParameter(query: title, display: 100, sort: Sort.sim.rawValue)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    @objc func sortDateTapped() {
        guard let title else { return }
        let parmeter = ShopSearchParameter(query: title, display: 100, sort: Sort.date.rawValue)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    @objc func sortDscTapped() {
        guard let title else { return }
        let parmeter = ShopSearchParameter(query: title, display: 100, sort: Sort.dsc.rawValue)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    @objc func sortAscTapped() {
        guard let title else { return }
        let parmeter = ShopSearchParameter(query: title, display: 100, sort: Sort.asc.rawValue)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    func makeList(url: URL?) {
        guard let url, urlString != url.absoluteString else {
            print("중복방지")
            return
        }
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                self.itemData = itemData
                urlString = url.absoluteString
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
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
