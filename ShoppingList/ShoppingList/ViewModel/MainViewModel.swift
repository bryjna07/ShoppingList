//
//  MainViewModel.swift
//  ShoppingList
//
//  Created by YoungJin on 8/12/25.
//

import Foundation

// 에러가 많아진다면?
// 모든 것을 에러로 처리는 할 수 있음
// 명확한 구분 ? 비슷한 것 끼리
// 토스트의 경우 스트링만 보내는 것도 방법
enum MainError: Error {
    case isEmpty
    case textCount
    case urlFail
}

final class MainViewModel {
    
    private let networkManager = NetworkManager.shared
    
    var input: Input
    var output: Output
    
    struct Input {
        // 1. 검색어 입력
        var searchText: Observable<String?> = Observable(nil)
        // 2. 서치버튼 - 에러처리, 네트워킹
        var searchButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        // 인디케이터 on/off 상태
        var indicatorStatus: Observable<Bool> = Observable(false)
        // 아이템 수 0개
        var noResult: Observable<Void> = Observable(())
        // 에러
        var error: Observable<MainError?> = Observable(nil)
        // 뷰모델 ?
        var result: Observable<Result<SearchListViewModel, CustomError>?> = Observable(nil)
    }
    
    init() {
        input = Input()
        output = Output()
        
        input.searchText.lazyBind { [weak self] text in
            guard let text else { return }
            do throws(MainError) {
                _ = try self?.fetchRequset(text: text)
            } catch {
                self?.output.error.value = error
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
        
        output.indicatorStatus.value = true
        
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                output.indicatorStatus.value = false
                if itemData.total == 0 {
                    self.output.noResult.value = ()
                } else {
                    guard let title = self.input.searchText.value else { return }
                    let viewModel = SearchListViewModel(title: title, data: itemData, urlString: url.absoluteString)
                    self.output.result.value = .success(viewModel)
                }
            case .failure(let error):
                self.output.result.value = .failure(error)
                output.indicatorStatus.value = false
            }
        }
    }
}
