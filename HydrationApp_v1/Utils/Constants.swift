//
//  Constants.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

struct Constants {
    // Hydration
    static let defaultDailyGoal = 2000.0 // ml
    static let minDailyGoal = 1000.0 // ml
    static let maxDailyGoal = 5000.0 // ml
    
    // Quick intake amounts
    static let smallIntake = 250.0 // ml
    static let mediumIntake = 500.0 // ml  
    static let largeIntake = 750.0 // ml
    
    // Notifications
    static let reminderInterval = 2 * 60 * 60 // 2 hours in seconds
    static let reminderHours = [8, 10, 12, 14, 16, 18, 20]
    
    // Weather thresholds
    static let hotTemperature = 25.0 // Celsius
    static let veryHotTemperature = 30.0 // Celsius
    static let lowHumidity = 0.4
    
    // UserDefaults keys
    static let hydrationStateKey = "HydrationState"
    static let userSettingsKey = "UserSettings"
    
    // Animation durations
    static let shortAnimation = 0.3
    static let mediumAnimation = 0.6
    static let longAnimation = 1.0
}
