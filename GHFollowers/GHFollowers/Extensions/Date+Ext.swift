//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Mikhail Ustyantsev on 17.02.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
