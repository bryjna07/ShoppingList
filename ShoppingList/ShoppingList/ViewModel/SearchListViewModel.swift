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
    private var parameter = NaverShopSearchParameter(query: "")
    private var currentSort = Sort.sim
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
    
    init(title: String, data: ItemData) {
        input = Input()
        output = Output()
        self.output.title.value = title
        self.output.totalString.value = data.totalString
        self.output.itemList.value = data.items
        self.parameter = NaverShopSearchParameter(query: title)
        
        input.simButtonTapped.lazyBind { [weak self] _ in
            self?.sort(type: .sim)
        }
        input.dateButtonTapped.lazyBind { [weak self] _ in
            self?.sort(type: .date)
        }
        input.ascButtonTapped.lazyBind { [weak self] _ in
            self?.sort(type: .asc)
        }
        input.dscButtonTapped.lazyBind { [weak self] _ in
            self?.sort(type: .dsc)
        }
    }
    
    private func sort(type: Sort) {
        guard currentSort != type else { return }
        currentSort = type
        parameter.sort = type.rawValue
        let api = Router.naverShopSearch(parameter)
        makeList(api: api)
    }
    
    private func makeList(api: Router) {
        
        output.indicatorStatus.value = true
        networkManager.fetchData(api: api) { [weak self] (result: Result<ItemData, CustomError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                output.itemList.value = itemData.items
                output.indicatorStatus.value = false
                output.scrollToItem.value = ()
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}
