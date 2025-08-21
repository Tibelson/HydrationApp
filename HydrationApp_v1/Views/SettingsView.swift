//
//  SettingsView.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import SwiftUI
import Observation

struct SettingsView: View {
    @Bindable private var hydrationManager = HydrationManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var tempGoal: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Daily Goal") {
                    HStack {
                        TextField("Goal (ml)", text: $tempGoal)
                            .keyboardType(.numberPad)
                        Text("ml")
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Recommended: 2000ml - 3000ml per day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Notifications") {
                    Toggle("Reminder Notifications", isOn: Binding(
                        get: { hydrationManager.userSettings.remindersEnabled },
                        set: { newValue in
                            hydrationManager.userSettings.remindersEnabled = newValue
                            if newValue {
                                NotificationManager.shared.scheduleNotifications()
                            } else {
                                NotificationManager.shared.cancelPendingNotifications()
                            }
                        }
                    ))
                }
                
                Section("Statistics") {
                    HStack {
                        Text("Current Streak")
                        Spacer()
                        Text("\(hydrationManager.hydrationState.streak) days")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Today's Progress")
                        Spacer()
                        Text("\(Int(hydrationManager.getProgressPercentage() * 100))%")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Actions") {
                    Button("Reset Today's Progress") {
                        hydrationManager.hydrationState.dailyIntake = 0
                        hydrationManager.hydrationState.isThirsty = true
                    }
                    .foregroundColor(.red)
                    
                    Button("Reset Streak") {
                        hydrationManager.hydrationState.streak = 0
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                        dismiss()
                    }
                }
            }
            .onAppear {
                tempGoal = String(Int(hydrationManager.hydrationState.goal))
            }
        }
    }
    
    private func saveSettings() {
        if let goal = Double(tempGoal), goal > 0 {
            hydrationManager.updateGoal(goal)
        }
    }
}
