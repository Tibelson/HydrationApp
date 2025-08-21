//
//  DateExtension.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import Foundation

extension Date {
    func isSameDay(as other: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: other)
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfDay()) ?? self
    }
    
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func hoursSince() -> Int {
        let timeInterval = Date().timeIntervalSince(self)
        return Int(timeInterval / 3600)
    }
}
