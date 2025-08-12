//
//  MainViewModel.swift
//  ShoppingList
//
//  Created by YoungJin on 8/12/25.
//

import Foundation

final class MainViewModel {
    
    private let networkManager = NetworkManager.shared
    // Input
    // 1. 검색어 입력
    var inputSearchText: Observable<String?> = Observable(nil)
    // 2. 서치버튼 - 에러처리, 네트워킹
    var inputSearchButtonTapped: Observable<Void> = Observable(())
    
    // Output
    // 1. 검색 결과 리스트(Data)
    // 2글자 미만 검증 결과
    var outputTextValidate: Observable<Bool> = Observable(false)
    // url 오류
    var outputURLFailed: Observable<Void> = Observable(())
    // 인디케이터 on/off 상태
    var outputIndicatorStatus: Observable<Bool> = Observable(false)
    // 아이템 결과?
    var outputItemResult: Observable<ItemData?> = Observable(nil)
    // 아이템 수 0개
    var outputNoResult: Observable<Bool> = Observable(false)
    // 에러
    var outputError: Observable<CustomError?> = Observable(nil)
    // VC -> VM -> VM -> VC
    // 뷰모델 ?
    var outputViewModel: Observable<SearchListViewModel?> = Observable(nil)
    
    init() {
//        inputSearchText.bind { [weak self] text in
//            // 글자 수 검증
//            
//        }
        
        inputSearchButtonTapped.lazyBind { [weak self] _ in
            guard let text = self?.inputSearchText.value else { return }
            let url = self?.fetchRequset(text: text)
            self?.fetchItem(url: url)
            // 네트워킹, outputSearchList 할당 or 에러 할당
        }
    }
    
    private func fetchRequset(text: String?) -> URL? {
        guard let text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            outputTextValidate.value = true
            return nil
        }
        
        outputIndicatorStatus.value = true

        /// 검색 메서드 실행
        let parmeter = ShopSearchParameter(query: text, display: 30)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)

        /// 네이버 에러응답 테스트 URL
        //        let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?query=마우스&display=10&sort=si")
        return url
    }
    
    private func fetchItem(url: URL?) {
        guard let url else {
            outputURLFailed.value = ()
            return
        }
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, CustomError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                self.outputItemResult.value = itemData
                outputIndicatorStatus.value = false
                if itemData.total == 0 {
                    self.outputNoResult.value = true
                } else {
                    self.outputNoResult.value = false
                    guard let title = self.inputSearchText.value else { return }
                    self.outputViewModel.value = SearchListViewModel(title: title, data: itemData, urlString: url.absoluteString)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
}
