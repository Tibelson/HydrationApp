//
//  HyddrationWidgetView.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import SwiftUI
import WidgetKit

struct HydrationWidgetView: View {
    var entry: HydrationEntry
    
    var body: some View {
        VStack(spacing: 8) {
            // Compact header
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
                Text("Hydration")
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(entry.progress * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(entry.progress >= 1.0 ? .green : .blue)
            }
            
            // Progress visualization
            ZStack {
                // Smaller progress ring for widget
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 6)
                    
                    Circle()
                        .trim(from: 0.0, to: entry.progress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 60, height: 60)
                
                // Center info
                VStack(spacing: 2) {
                    Text("\(Int(entry.dailyIntake))")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("ml")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Bottom info
            HStack {
                // Streak
                HStack(spacing: 4) {
                    Image(systemName: entry.streak > 0 ? "flame.fill" : "flame")
                        .foregroundColor(entry.streak > 0 ? .orange : .gray)
                        .font(.caption)
                    Text("\(entry.streak)")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                // Status
                Text(entry.isThirsty ? "Thirsty" : "Hydrated")
                    .font(.caption2)
                    .foregroundColor(entry.isThirsty ? .orange : .green)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
    }
}
