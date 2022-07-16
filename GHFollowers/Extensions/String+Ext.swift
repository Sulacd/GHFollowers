//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/13/22.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        // Format the settings for the string you want a date representation for
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        // Returns the string as a date object as long as it matches the specified format
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = convertToDate() else {return "N/A"}
        return date.convertToMonthYearFormat()
    }
}
