//
//  SearchListViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import Alamofire
import Toast

final class SearchListViewController: UIViewController {
    
    private let listView = SearchListView()
    private var viewModel: SearchListViewModel
    
    init(viewModel: SearchListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        binding()
        buttonActionSetup()
        //        makeHorizontalList()
    }
    
    private func binding() {
        
        viewModel.output.title.bind { [weak self] title in
            self?.navigationItem.title = title
        }
        
        viewModel.output.totalString.bind { [weak self] string in
            self?.listView.resultCountLabel.text = string
        }
        
        viewModel.output.itemList.lazyBind { [weak self] list in
            print("lazy bind")
            self?.listView.collectionView.reloadData()
        }
        
        viewModel.output.indicatorStatus.lazyBind { [weak self] bool in
            bool ? self?.listView.activityIndicatorView.startAnimating() : self?.listView.activityIndicatorView.stopAnimating()
        }
        
        viewModel.output.scrollToItem.lazyBind { [weak self] _ in
            self?.listView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    private func setupCollectionView() {
        listView.collectionView.delegate = self
        listView.collectionView.dataSource = self
        //        listView.collectionView.prefetchDataSource = self
        listView.horizontalCollectionView.delegate = self
        listView.horizontalCollectionView.dataSource = self
    }
    
    //    private func makeHorizontalList() {
    //        listView.activityIndicatorView.startAnimating()
    //        let param = NaverShopSearchParameter(query: "아이폰")
    //        let endPoint = NaverShopSearchParameter(param)
    //        let url = networkManager.makeURL(from: endPoint)
    //        guard let url else { return }
    //        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
    //            guard let self else { return }
    //            switch result {
    //            case .success(let itemData):
    //                self.horizontalList = itemData.items
    //                listView.activityIndicatorView.stopAnimating()
    //                self.listView.horizontalCollectionView.reloadData()
    //            case .failure(let error):
    //                print("데이터 불러오기 실패: \(error.localizedDescription)")
    //            }
    //        }
    //    }
    
    private func buttonActionSetup() {
        listView.sortViews[0].button.addTarget(self, action: #selector(sortSimTapped), for: .touchUpInside)
        listView.sortViews[1].button.addTarget(self, action: #selector(sortDateTapped), for: .touchUpInside)
        listView.sortViews[2].button.addTarget(self, action: #selector(sortAscTapped), for: .touchUpInside)
        listView.sortViews[3].button.addTarget(self, action: #selector(sortDscTapped), for: .touchUpInside)
    }
    
    @objc private func sortSimTapped() {
        viewModel.input.simButtonTapped.value = ()
    }
    @objc private func sortDateTapped() {
        viewModel.input.dateButtonTapped.value = ()
    }
    @objc private func sortAscTapped() {
        viewModel.input.ascButtonTapped.value = ()
    }
    @objc private func sortDscTapped() {
        viewModel.input.dscButtonTapped.value = ()
    }
}

///Mark: - CollectionView Protocols
extension SearchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == listView.collectionView {
            return viewModel.output.itemList.value.count
        } else if collectionView == listView.horizontalCollectionView {
            return viewModel.horizontalList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listView.collectionView {
            guard let cell = listView.collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.id, for: indexPath) as? ItemCell else { return UICollectionViewCell() }
            cell.item = viewModel.output.itemList.value[indexPath.row]
            return cell
        } else if collectionView == listView.horizontalCollectionView {
            guard let cell = listView.horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: horizontalCell.id, for: indexPath) as? horizontalCell else { return UICollectionViewCell() }
            cell.item = viewModel.horizontalList[indexPath.row]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

//extension SearchListViewController: UICollectionViewDataSourcePrefetching {
//
//    // indexpath가 count 갯수 - 10 일때 미리 불러오기
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        if collectionView == listView.collectionView {
//            guard !isLoading else {
//                print("두번호출")
//                return
//            }
//
//            let lastItem = indexPaths.map { $0.item }.sorted(by: <).last
//
//            guard let lastItem else { return }
//            if list.count > 29, lastItem >= list.count - 10 {
//                if self.parameter?.start == 1 {
//                    self.parameter?.start += 30
//                }
//                guard let param = self.parameter else { return }
//
//                isLoading = true // 중복호출 방지
//
//                guard let url = networkManager.makeURL(from: NaverShopSearchParameter(param)) else { return }
//                print(url)
//                networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
//                    guard let self else { return }
//                    switch result {
//                    case .success(let itemData):
//                        self.list.append(contentsOf: itemData.items)
//                        self.listView.collectionView.reloadData()
//                        self.parameter?.start += 30
//                        self.urlString = url.absoluteString
//                        isLoading = false
////                        prefetchNumber = itemNum
//                    case .failure(let error):
//                        print("데이터 불러오기 실패: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//
//    }
//
//
//    // 취소 , count 갯수가 일정 수 넘어갈 때
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        if collectionView == listView.collectionView {
//            guard let itemData else { return }
//            print(itemData.total, list.count)
//            if itemData.total <= list.count {
//                self.parameter = nil
//            }
//        }
//    }
//}
