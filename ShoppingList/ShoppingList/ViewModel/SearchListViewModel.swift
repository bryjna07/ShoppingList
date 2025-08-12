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
    
    // Input
    var inputSimButtonTapped: Observable<Void> = Observable(())
    var inputDateButtonTapped: Observable<Void> = Observable(())
    var inputDscButtonTapped: Observable<Void> = Observable(())
    var inputAscButtonTapped: Observable<Void> = Observable(())
    
    // Output
    var outputTitle = Observable("")
    var outputTotalString = Observable("")
    var outputItemList: Observable<[Item]> = Observable([])
    // 인디케이터 on/off 상태
    var outputIndicatorStatus: Observable<Bool> = Observable(false)
    // 스크롤 위로
    var outputScrollToItem: Observable<Void> = Observable(())
    
    init(title: String, data: ItemData, urlString: String) {
        self.outputTitle.value = title
        self.outputTotalString.value = data.totalString
        self.outputItemList.value = data.items
        self.parameter = ShopSearchParameter(query: title)
        self.urlString = urlString
        
        inputSimButtonTapped.lazyBind { [weak self] _ in
            self?.sortSim()
        }
        
        inputDateButtonTapped.lazyBind { [weak self] _ in
            self?.sortDate()
        }
        
        inputAscButtonTapped.lazyBind { [weak self] _ in
            self?.sortAsc()
        }
        
        inputDscButtonTapped.lazyBind { [weak self] _ in
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
        outputIndicatorStatus.value = true
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                outputItemList.value = itemData.items
                urlString = url.absoluteString
                outputIndicatorStatus.value = false
                outputScrollToItem.value = ()
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}
