//
//  NotificationManager.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Notifications granted: \(granted)")
                if granted {
                    self.scheduleNotifications()
                }
            }
    }
    
    func scheduleNotifications() {
        // Cancel existing notifications
        cancelPendingNotifications()
        
        let center = UNUserNotificationCenter.current()
        
        // Schedule reminders every 2 hours from 8 AM to 8 PM
        let reminderTimes = Constants.reminderHours
        
        for hour in reminderTimes {
            let content = UNMutableNotificationContent()
            content.title = "💧 Time to Hydrate!"
            content.body = getRandomReminderMessage()
            content.sound = .default
            content.categoryIdentifier = "HYDRATION_REMINDER"
            
            // Add quick action buttons
            let drinkAction = UNNotificationAction(
                identifier: "DRINK_250ML",
                title: "Drank 250ml",
                options: [.foreground]
            )
            
            let drinkMoreAction = UNNotificationAction(
                identifier: "DRINK_500ML", 
                title: "Drank 500ml",
                options: [.foreground]
            )
            
            let category = UNNotificationCategory(
                identifier: "HYDRATION_REMINDER",
                actions: [drinkAction, drinkMoreAction],
                intentIdentifiers: []
            )
            
            center.setNotificationCategories([category])
            
            // Schedule for every day at this hour
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "hydration-\(hour)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    }
    
    func cancelPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func getRandomReminderMessage() -> String {
        let messages = [
            "Your body is calling for water! 💦",
            "Stay hydrated, stay healthy! 🌟",
            "Time for a refreshing drink! 🥤",
            "Don't forget to drink water! 💧",
            "Keep that streak going! 🔥",
            "Your future self will thank you! ✨"
        ]
        return messages.randomElement() ?? "Time to drink water!"
    }
    
    func handleNotificationAction(identifier: String) {
        switch identifier {
        case "DRINK_250ML":
            HydrationManager.shared.addIntake(amount: Constants.smallIntake)
        case "DRINK_500ML":
            HydrationManager.shared.addIntake(amount: Constants.mediumIntake)
        default:
            break
        }
    }
}
