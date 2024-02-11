//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 11.02.2024.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(fonSize: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fonSize, weight: .medium)
        configure()
    }
    
    
    private func configure() {
        textColor                     = .secondaryLabel
        adjustsFontSizeToFitWidth     = true
        minimumScaleFactor            = 0.9
        lineBreakMode                 = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
