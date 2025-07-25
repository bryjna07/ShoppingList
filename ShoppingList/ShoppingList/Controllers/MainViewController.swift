//
//  MainViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit
import Toast

final class MainViewController: UIViewController {
    
    let mainView = MainView()
    
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

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            view.makeToast("검색어를 입력해주세요")
            return
        }
        
        let vc = SearchListViewController(title: text)
        navigationController?.pushViewController(vc, animated: true)
    }
}
