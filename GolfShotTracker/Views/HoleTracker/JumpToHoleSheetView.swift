//
//  JumpToHoleSheetView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Jump to Hole Sheet View
//
//  Modal sheet that allows users to quickly navigate to any hole in the current round.
//  Useful for jumping to specific holes (e.g., starting on hole 10, correcting a mistake).
//
//  Features:
//  - Wheel picker for hole selection
//  - Shows all holes in the round (1 to totalHoles)
//  - Cancel and Go buttons
//  - Calls completion handler with selected hole number
//
//  Usage:
//  - Accessed from HoleTrackerView's toolbar
//  - Allows quick navigation without tapping through multiple holes
//

import SwiftUI

struct JumpToHoleSheetView: View {
    @Environment(\.dismiss) private var dismiss
    let totalHoles: Int
    let onHoleSelected: (Int) -> Void
    
    @State private var selectedHole: Int = 1
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Hole", selection: $selectedHole) {
                        ForEach(1...totalHoles, id: \.self) { holeNumber in
                            Text("Hole \(holeNumber)").tag(holeNumber)
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("Select Hole")
                }
            }
            .navigationTitle("Jump to Hole")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Go") {
                        onHoleSelected(selectedHole)
                        dismiss()
                    }
                }
            }
        }
    }
}

