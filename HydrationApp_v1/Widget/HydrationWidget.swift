//
//  HydrationWidget.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import WidgetKit
import SwiftUI


struct HydrationWidget: Widget {
    let kind: String = "HydrationWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HydrationTimelineProvider()) { entry in
            HydrationWidgetView(entry: entry)
        }
        .configurationDisplayName("Hydration Tracker")
        .description("Track your daily water intake and maintain your streak!")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
