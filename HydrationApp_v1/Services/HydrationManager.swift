//
//  HydrationManager.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class HydrationManager {
    static let shared = HydrationManager()
    
    // These are stored properties, not computed, so @Observable works fine
    var hydrationState: HydrationState
    var userSettings: UserSettings
    
    private init() {
        // Defaults
        self.hydrationState = HydrationState(
            lastDrink: Date(),
            dailyIntake: 0,
            goal: Constants.defaultDailyGoal,
            streak: 0,
            isThirsty: true
        )
        
        self.userSettings = UserSettings(
            dailyGoal: Constants.defaultDailyGoal,
            remindersEnabled: true
        )
        
        loadData()
        setupDailyReset()
    }
    
    // MARK: - Public Methods
    func addIntake(amount: Double) {
        hydrationState.dailyIntake += amount
        hydrationState.lastDrink = Date()
        hydrationState.isThirsty = hydrationState.dailyIntake < hydrationState.goal
        
        saveData()
        
        // Cancel notifications if goal is reached
        if hydrationState.dailyIntake >= hydrationState.goal {
            NotificationManager.shared.cancelPendingNotifications()
        }
    }
    
    func checkDailyGoal() {
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(hydrationState.lastDrink, inSameDayAs: today) {
            if hydrationState.dailyIntake >= hydrationState.goal {
                hydrationState.streak += 1
            } else {
                hydrationState.streak = 0
            }
            
            hydrationState.dailyIntake = 0
            hydrationState.isThirsty = true
            saveData()
        }
    }
    
    func updateGoal(_ newGoal: Double) {
        hydrationState.goal = newGoal
        userSettings.dailyGoal = newGoal
        hydrationState.isThirsty = hydrationState.dailyIntake < hydrationState.goal
        saveData()
    }
    
    func getProgressPercentage() -> Double {
        return min(hydrationState.dailyIntake / hydrationState.goal, 1.0)
    }
    
    // MARK: - Persistence
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: Constants.hydrationStateKey),
           let state = try? JSONDecoder().decode(HydrationState.self, from: data) {
            hydrationState = state
        }
        
        if let data = UserDefaults.standard.data(forKey: Constants.userSettingsKey),
           let settings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            userSettings = settings
            hydrationState.goal = settings.dailyGoal
        }
    }
    
    private func saveData() {
        if let data = try? JSONEncoder().encode(hydrationState) {
            UserDefaults.standard.set(data, forKey: Constants.hydrationStateKey)
        }
        
        if let data = try? JSONEncoder().encode(userSettings) {
            UserDefaults.standard.set(data, forKey: Constants.userSettingsKey)
        }
    }
    
    // MARK: - Daily Reset
    private func setupDailyReset() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.checkDailyGoal()
        }
    }
}

