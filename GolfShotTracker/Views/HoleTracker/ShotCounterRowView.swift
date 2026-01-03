//
//  ShotCounterRowView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

