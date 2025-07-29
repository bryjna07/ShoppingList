//
//  MainViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import Toast
import Alamofire

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    private let networkManager = NetworkManager.shared
    
    private var itemData: ItemData?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    
    private func setUpViewController() {
        title = "영캠러의 쇼핑쇼핑"
        mainView.searchBar.delegate = self
    }
}

///Mark: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            ///TODO: - 2글자 미만 알럿, 클로저
            view.makeToast("검색어를 입력해주세요", position: .top)
            return
        }
        
        mainView.activityIndicatorView.startAnimating()
        
        /// 검색 메서드 실행
        let parmeter = ShopSearchParameter(query: text, display: 30)
        let endPoint = NaverAPI.shopSearch(parmeter)
        let url = networkManager.makeURL(from: endPoint)
        
        /// 네이버 에러응답 테스트 URL
        //        let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?query=마우스&display=10&sort=si")
        guard let url else {
            view.makeToast("준비중입니다", position: .top)
            return
        }
        print(url.absoluteString)
        networkManager.fetchData(url: url) { [weak self] (result: Result<ItemData, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let itemData):
                self.itemData = itemData
                mainView.activityIndicatorView.stopAnimating()
                navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error)
            }
        } naverError: { [weak self] message in
            if message.errorCode == "SE99" {
                self?.view.makeToast("서버오류", position: .top) /// 재요청 or 에러뷰(네트워크 오류안내)
            } else {
                self?.view.makeToast(message.errorMessage, position: .top) /// 에러응답 테스트용
            }
        }
    }
}
