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
//    private var parameter : ShopSearchParameter?
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
    
    init(title: String, data: ItemData, urlString: String) {
        self.outputTitle.value = title
        self.outputTotalString.value = data.totalString
        self.outputItemList.value = data.items
//        self.parameter = ShopSearchParameter(query: title)
        self.urlString = urlString
    }
}
