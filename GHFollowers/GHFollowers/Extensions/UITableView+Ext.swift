//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 09.03.2024.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
