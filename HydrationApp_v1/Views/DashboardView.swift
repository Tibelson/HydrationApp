//
//  DashboardView.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//
import SwiftUI
import Observation

struct DashboardView: View {
    @Bindable private var hydrationManager = HydrationManager.shared
    @Bindable private var weatherService = WeatherService.shared
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("Stay Hydrated!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Daily Goal: \(Int(hydrationManager.hydrationState.goal))ml")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Weather recommendation
                    if let weather = weatherService.currentWeather {
                        Text(weather.recommendation)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                    }
                }
                
                // Progress Ring with overlay text
                ZStack {
                    ProgressRing(progress: hydrationManager.getProgressPercentage())
                    
                    VStack {
                        Text("\(Int(hydrationManager.hydrationState.dailyIntake))ml")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("of \(Int(hydrationManager.hydrationState.goal))ml")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Mascot
                MascotView(isThirsty: hydrationManager.hydrationState.isThirsty)
                
                // Streak
                StreakView(streak: hydrationManager.hydrationState.streak)
                
                // Quick add buttons
                HStack(spacing: 15) {
                    IntakeButton(amount: Constants.smallIntake, hydrationManager: hydrationManager)
                    IntakeButton(amount: Constants.mediumIntake, hydrationManager: hydrationManager)
                    IntakeButton(amount: Constants.largeIntake, hydrationManager: hydrationManager)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Hydration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        showingSettings = true
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .onAppear {
                hydrationManager.checkDailyGoal()
                Task {
                    await weatherService.fetchWeather()
                }
            }
        }
    }
}

struct IntakeButton: View {
    let amount: Double
    let hydrationManager: HydrationManager
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                hydrationManager.addIntake(amount: amount)
            }
        }) {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                Text("\(Int(amount))ml")
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 80, height: 60)
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}

#Preview {
    DashboardView()
}

