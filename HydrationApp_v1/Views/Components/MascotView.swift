//
//  MascotView.swift
//  HydrationApp_v1
//
//  Created by Junior Elvis on 8/18/25.
//

import SwiftUI

struct MascotView: View {
    var isThirsty: Bool
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Water drop background effect
                if !isThirsty {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.2), .clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.6)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                // Main mascot icon
                Image(systemName: isThirsty ? "drop" : "drop.fill")
                    .font(.system(size: 60))
                    .foregroundColor(isThirsty ? .gray : .blue)
                    .scaleEffect(isThirsty ? 0.8 : 1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isThirsty)
            }
            
            // Status text
            Text(isThirsty ? "I'm thirsty! 😢" : "Feeling great! 😊")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isThirsty ? .orange : .green)
                .animation(.easeInOut(duration: 0.3), value: isThirsty)
        }
        .onAppear {
            if !isThirsty {
                isAnimating = true
            }
        }
        .onChange(of: isThirsty) { oldValue, newValue in
            isAnimating = !newValue
        }
    }
}
