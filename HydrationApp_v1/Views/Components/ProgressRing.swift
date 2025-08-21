//
//  ProgressRing.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//
import SwiftUI

struct ProgressRing: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 12)
            
            // Progress ring
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)
            
            // Completion celebration
            if progress >= 1.0 {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
                    .scaleEffect(1.2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: progress)
            }
        }
        .frame(width: 150, height: 150)
    }
}
