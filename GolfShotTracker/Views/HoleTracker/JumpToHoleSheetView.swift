//
//  JumpToHoleSheetView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

