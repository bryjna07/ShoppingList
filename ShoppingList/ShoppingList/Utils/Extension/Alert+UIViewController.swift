//
//  Alert+UIViewController.swift
//  SeSAC7Week1Remind
//
//  Created by YoungJin on 7/7/25.
//

import UIKit

extension UIViewController {
    // 알럿
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}
