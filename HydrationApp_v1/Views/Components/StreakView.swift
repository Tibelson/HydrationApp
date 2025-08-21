//
//  StreakView.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import SwiftUI

struct StreakView: View {
    var streak: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: streak > 0 ? "flame.fill" : "flame")
                    .foregroundColor(streak > 0 ? .orange : .gray)
                    .font(.title2)
                
                Text("\(streak)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(streak > 0 ? .orange : .gray)
            }
            
            Text(streak == 1 ? "day streak" : "days streak")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .scaleEffect(streak > 0 ? 1.0 : 0.9)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: streak)
    }
}
