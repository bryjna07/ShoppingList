//
//  SearchListViewModel.swift
//  ShoppingList
//
//  Created by YoungJin on 8/12/25.
//

import Foundation

final class SearchListViewModel {
    
    // Data
    var horizontalList: [Item] = []
    private var parameter = ShopSearchParameter(query: "")
    private var urlString = ""
    //    private var currentStart = 1
    //    private var prefetchNumber = 0
    //    private var isLoading = false
    
    // Manager
    private let numberFormatter = YJFormatter.shared
    private let networkManager = NetworkManager.shared
    
    var input: Input
    var output: Output
    
    struct Input {
        var simButtonTapped: Observable<Void> = Observable(())
        var dateButtonTapped: Observable<Void> = Observable(())
        var dscButtonTapped: Observable<Void> = Observable(())
        var ascButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        // Output
        var title = Observable("")
        var totalString = Observable("")
        var itemList: Observable<[Item]> = Observable([])
        // 인디케이터 on/off 상태
        var indicatorStatus: Observable<Bool> = Observable(false)
        // 스크롤 위로
        var scrollToItem: Observable<Void> = Observable(())
    }
    
    init(title: String, data: ItemData, urlString: String) {
        input = Input()
        output = Output()
        self.output.title.value = title
        self.output.totalString.value = data.totalString
        self.output.itemList.value = data.items
        self.parameter = ShopSearchParameter(query: title)
        self.urlString = urlString
        
        input.simButtonTapped.lazyBind { [weak self] _ in
            self?.sortSim()
        }
        input.dateButtonTapped.lazyBind { [weak self] _ in
            self?.sortDate()
        }
        input.ascButtonTapped.lazyBind { [weak self] _ in
            self?.sortAsc()
        }
        input.dscButtonTapped.lazyBind { [weak self] _ in
            self?.sortDsc()
        }
    }
    
    private func sortSim() {
        parameter.sort = Sort.sim.rawValue
        let endPoint = NaverAPI.shopSearch(parameter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    private func sortDate() {
        parameter.sort = Sort.date.rawValue
        let endPoint = NaverAPI.shopSearch(parameter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    private func sortDsc() {
        parameter.sort = Sort.dsc.rawValue
        let endPoint = NaverAPI.shopSearch(parameter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    private func sortAsc() {
        parameter.sort = Sort.asc.rawValue
        let endPoint = NaverAPI.shopSearch(parameter)
        let url = networkManager.makeURL(from: endPoint)
        makeList(url: url)
    }
    
    private func makeList(url: URL?) {
        guard let url, urlString != url.absoluteString else {
            print("중복방지")
            return
        }
        output.indicatorStatus.value = true
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                output.itemList.value = itemData.items
                urlString = url.absoluteString
                output.indicatorStatus.value = false
                output.scrollToItem.value = ()
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}
