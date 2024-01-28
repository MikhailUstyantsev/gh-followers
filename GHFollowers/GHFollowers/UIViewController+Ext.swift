//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 29.01.2024.
//

import UIKit


extension UIViewController {
    
    func presentGFAlertOnMainTread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
