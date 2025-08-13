//
//  MainViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import Toast

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        binding()
    }
    
    private func binding() {
        
        // 인디케이터 바인딩
        viewModel.output.indicatorStatus.lazyBind { [weak self] bool in
            bool ? self?.mainView.activityIndicatorView.startAnimating() : self?.mainView.activityIndicatorView.stopAnimating()
        }
        
        // 아이템 갯수 0개일 때 알럿
        viewModel.output.noResult.lazyBind { [weak self] _ in
            self?.showAlert(title: "검색결과 없음", message: "다른 검색어로 이용해보세요")
            self?.mainView.searchBar.text = ""
        }
        
        // 에러가 있으면 실행
        viewModel.output.error.lazyBind { [weak self] error in
            guard let self, let error else { return }
            switch error {
            case .isEmpty:
                self.view.makeToast("검색어를 입력해주세요", position: .top)
            case .textCount:
                self.view.makeToast("2글자 이상 입력해주세요", position: .top)
            case .urlFail:
                self.view.makeToast("준비중입니다", position: .top)
            }
        }
        
        // 결과 바인딩 - 뷰모델 만들기 성공 -> 화면이동, 실패 -> 알럿
        viewModel.output.result.lazyBind { [weak self] (result: Result<SearchListViewModel, CustomError>?) in
            guard let result else { return }
            switch result {
            case .success(let viewModel):
                let vc = SearchListViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                switch error {
                case .naverError(let naverError):
                    self?.showAlert(title: naverError.errorCode, message: naverError.errorMessage)
                case .afError(let afError):
                    print(afError?.localizedDescription ?? "")
                }
            }
        }
    }
    
    private func setUpViewController() {
        title = "영캠러의 쇼핑쇼핑"
        mainView.searchBar.delegate = self
    }
}

///Mark: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchText.value = searchBar.text
        viewModel.input.searchButtonTapped.value = ()
        
    }
}
