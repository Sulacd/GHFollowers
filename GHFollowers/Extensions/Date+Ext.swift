//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/13/22.
//

import Foundation

extension Date {
    
    // Converts Date Object to a String (Old Method)
//    func convertToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//
//        return dateFormatter.string(from: self)
//    }
    
    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
