//
//  HydrationEntry.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import WidgetKit

struct HydrationEntry: TimelineEntry {
    let date: Date
    let isThirsty: Bool
    let progress: Double
    let streak: Int
    let dailyIntake: Double
    let goal: Double
}

struct HydrationTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> HydrationEntry {
        HydrationEntry(
            date: Date(),
            isThirsty: false,
            progress: 0.7,
            streak: 5,
            dailyIntake: 1400,
            goal: 2000
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HydrationEntry) -> Void) {
        let hydrationManager = HydrationManager.shared
        let entry = HydrationEntry(
            date: Date(),
            isThirsty: hydrationManager.hydrationState.isThirsty,
            progress: hydrationManager.getProgressPercentage(),
            streak: hydrationManager.hydrationState.streak,
            dailyIntake: hydrationManager.hydrationState.dailyIntake,
            goal: hydrationManager.hydrationState.goal
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HydrationEntry>) -> Void) {
        let hydrationManager = HydrationManager.shared
        let currentDate = Date()
        
        let entry = HydrationEntry(
            date: currentDate,
            isThirsty: hydrationManager.hydrationState.isThirsty,
            progress: hydrationManager.getProgressPercentage(),
            streak: hydrationManager.hydrationState.streak,
            dailyIntake: hydrationManager.hydrationState.dailyIntake,
            goal: hydrationManager.hydrationState.goal
        )
        
        // Update widget every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
}
