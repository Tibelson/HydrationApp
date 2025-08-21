//
//  WeatherService.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import Foundation
import WeatherKit
import CoreLocation
import Observation

struct WeatherData: Codable {
    let temperature: Double // Celsius
    let humidity: Double    // 0-1
    let condition: String
    
    var hydrationMultiplier: Double {
        var multiplier = 1.0
        
        // Temperature adjustments
        if temperature > Constants.veryHotTemperature {
            multiplier += 0.4 // Very hot weather
        } else if temperature > Constants.hotTemperature {
            multiplier += 0.2 // Hot weather
        }
        
        // Humidity adjustments (lower humidity = more dehydration)
        if humidity < Constants.lowHumidity {
            multiplier += 0.1 // Dry air
        }
        
        return min(multiplier, 2.0) // Cap at 2x
    }
    
    var recommendation: String {
        if temperature > Constants.veryHotTemperature {
            return "🌡️ Very hot! Drink extra water today"
        } else if temperature > Constants.hotTemperature {
            return "☀️ Warm weather - stay hydrated!"
        } else if humidity < Constants.lowHumidity {
            return "🏜️ Dry air - drink more water"
        } else {
            return "🌤️ Perfect weather for staying hydrated"
        }
    }
}

@Observable
class WeatherService: NSObject, CLLocationManagerDelegate {
    static let shared = WeatherService()
    
    private let locationManager: CLLocationManager
    private let weatherService: WeatherKit.WeatherService
    
    // Observable state
    var currentWeather: WeatherData?
    var isLoading: Bool
    var errorMessage: String?
    
    override init() {
        self.locationManager = CLLocationManager()
        self.weatherService = WeatherKit.WeatherService()
        
        self.currentWeather = nil
        self.isLoading = false
        self.errorMessage = nil
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Public
    
    func fetchWeather() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Request location permission if needed
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
              locationManager.authorizationStatus == .authorizedAlways else {
            await MainActor.run {
                errorMessage = "Location access required for weather data"
                isLoading = false
            }
            return
        }
        
        guard let location = locationManager.location else {
            await MainActor.run {
                errorMessage = "Unable to get current location"
                isLoading = false
            }
            return
        }
        
        do {
            let weather = try await weatherService.weather(for: location)
            let currentConditions = weather.currentWeather
            
            let weatherData = WeatherData(
                temperature: currentConditions.temperature.value,
                humidity: currentConditions.humidity,
                condition: currentConditions.condition.description
            )
            
            await MainActor.run {
                currentWeather = weatherData
                isLoading = false
                updateHydrationGoalForWeather(weatherData)
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // MARK: - Hydration Goal Adjustment
    
    private func updateHydrationGoalForWeather(_ weather: WeatherData) {
        let baseGoal = HydrationManager.shared.userSettings.dailyGoal
        let adjustedGoal = baseGoal * weather.hydrationMultiplier
        
        if abs(adjustedGoal - HydrationManager.shared.hydrationState.goal) > baseGoal * 0.1 {
            HydrationManager.shared.hydrationState.goal = adjustedGoal
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            Task {
                await fetchWeather()
            }
        }
    }
}

