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
        
        // 텍스트 검증
        viewModel.outputTextValidate.lazyBind { [weak self] bool in
            if bool {
                ///TODO: - 2글자 미만 알럿, 클로저
                self?.view.makeToast("검색어를 입력해주세요", position: .top)
            }
        }
        
        // URL 실패 바인딩
        viewModel.outputURLFailed.lazyBind { [weak self] _ in
            self?.view.makeToast("준비중입니다", position: .top)
        }
        
        // 인디케이터 바인딩
        viewModel.outputIndicatorStatus.lazyBind { [weak self] bool in
            bool ? self?.mainView.activityIndicatorView.startAnimating() : self?.mainView.activityIndicatorView.stopAnimating()
        }
        
        // 아이템 갯수 0개일 때 알럿
        viewModel.outputNoResult.lazyBind { [weak self] bool in
            if bool {
                self?.showAlert(title: "검색결과 없음", message: "다른 검색어로 이용해보세요")
                self?.mainView.searchBar.text = ""
            }
        }
        
        // 에러가 있으면 실행
        viewModel.outputError.lazyBind { [weak self] error in
            guard let self, let error else { return }
            switch error {
            case .naverError(let naverError):
                self.showAlert(title: naverError.errorCode, message: naverError.errorMessage)
            case .afError(let afError):
                guard let afError else { return }
                print(afError)
            }
        }
        
        viewModel.outputViewModel.lazyBind { [weak self] viewModel in
            guard let viewModel else { return }
            let vc = SearchListViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
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
        viewModel.inputSearchText.value = searchBar.text
        viewModel.inputSearchButtonTapped.value = ()
      
    }
}
