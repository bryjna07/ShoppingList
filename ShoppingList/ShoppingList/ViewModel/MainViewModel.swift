//
//  MainViewModel.swift
//  ShoppingList
//
//  Created by YoungJin on 8/12/25.
//

import Foundation

enum MainError: Error {
    case isEmpty
    case textCount
    case urlFail
}

final class MainViewModel {
    
    private let networkManager = NetworkManager.shared
    // Input
    // 1. 검색어 입력
    var inputSearchText: Observable<String?> = Observable(nil)
    // 2. 서치버튼 - 에러처리, 네트워킹
    var inputSearchButtonTapped: Observable<Void> = Observable(())
    
    // Output
    // 인디케이터 on/off 상태
    var outputIndicatorStatus: Observable<Bool> = Observable(false)
    // 아이템 수 0개
    var outputNoResult: Observable<Void> = Observable(())
    // 에러
    var outputError: Observable<MainError?> = Observable(nil)
    // 뷰모델 ?
    var outputResult: Observable<Result<SearchListViewModel, CustomError>?> = Observable(nil)
    
    init() {
        
        inputSearchButtonTapped.lazyBind { [weak self] _ in
            guard let text = self?.inputSearchText.value else { return }
            do throws(MainError) {
                _ = try self?.fetchRequset(text: text)
            } catch {
                self?.outputError.value = error
            }
        }
    }
    
    private func fetchRequset(text: String?) throws(MainError) {
        guard let text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw .isEmpty
        }
        guard text.count > 1 else {
            throw .textCount
        }

        /// 검색 메서드 실행
        let parmeter = ShopSearchParameter(query: text, display: 30)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)

//        /// 네이버 에러응답 테스트 URL
//                let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?query=마우스&display=10&sort=si")

        guard let url else {
            throw .urlFail
        }
    
        outputIndicatorStatus.value = true
        
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                outputIndicatorStatus.value = false
                if itemData.total == 0 {
                    self.outputNoResult.value = ()
                } else {
                    guard let title = self.inputSearchText.value else { return }
                    let viewModel = SearchListViewModel(title: title, data: itemData, urlString: url.absoluteString)
                    self.outputResult.value = .success(viewModel)
                }
            case .failure(let error):
                self.outputResult.value = .failure(error)
                outputIndicatorStatus.value = false
            }
        }
    }
}
