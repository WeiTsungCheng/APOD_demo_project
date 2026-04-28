//
//  DateExtension.swift
//  APOD_demo_project
//
//  Created by WEITSUNG on 28/04/2026.
//

import Foundation

extension Date {
    
    static func fromAPODString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.date(from: string)
    }
    
    func addingDays(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
}
