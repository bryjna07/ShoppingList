//
//  SearchListViewController.swift
//  ShoppingList
//
//  Created by YoungJin on 7/25/25.
//

import UIKit

final class SearchListViewController: UIViewController {
    
    let listView = SearchListView()
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

}
