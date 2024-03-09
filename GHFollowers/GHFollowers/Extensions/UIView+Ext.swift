//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 09.03.2024.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
