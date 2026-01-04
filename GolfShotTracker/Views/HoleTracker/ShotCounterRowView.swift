//
//  ShotCounterRowView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Shot Counter Row View
//
//  A reusable component for displaying and controlling a single shot type counter.
//  Provides large, easy-to-tap buttons for fast on-course shot entry.
//
//  Features:
//  - Label with icon for shot type identification
//  - Large decrement button (disabled when count is 0)
//  - Prominent count display
//  - Large increment button
//  - Rounded background for visual separation
//  - Full VoiceOver accessibility support
//
//  Design:
//  - Large tap targets for fat-finger friendly interaction
//  - Color-coded buttons (red for decrement, green for increment)
//  - Bold count display for quick scanning
//
//  Usage:
//  - Used in HoleTrackerView for each shot type
//  - Each instance tracks one shot type (drives, putts, etc.)
//

import SwiftUI

struct ShotCounterRowView: View {
    let title: String
    let icon: String
    let count: Int
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.headline)
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            Button {
                onDecrement()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .disabled(count == 0)
            .accessibilityLabel("Decrement \(title)")
            
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .frame(minWidth: 50)
                .accessibilityLabel("\(title): \(count)")
            
            Button {
                onIncrement()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Increment \(title)")
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

