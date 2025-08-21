//
//  HydrationState.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//
import Foundation

struct HydrationState: Codable {
    var lastDrink: Date
    var dailyIntake: Double
    var goal: Double
    var streak: Int
    var isThirsty: Bool
}


