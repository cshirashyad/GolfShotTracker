//
//  NewRoundSheetView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - New Round Sheet View
//
//  Modal sheet for creating a new golf round. Collects course name and
//  number of holes before starting the round.
//
//  Features:
//  - Course name text input (required)
//  - Holes count picker (9 or 18, default: 18)
//  - Form validation (Begin button disabled until valid)
//  - Creates new Round with all holes initialized
//  - Calls completion handler with created round
//
//  User Flow:
//  - User enters course name and selects holes
//  - Taps "Begin Round" → Creates round → Dismisses → Opens HoleTrackerView
//
//  Dependencies:
//  - NewRoundViewModel: Manages form state and round creation
//  - DataServiceProtocol: For creating the round
//

import SwiftUI

struct NewRoundSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NewRoundViewModel
    let user: User?
    let onRoundCreated: (Round) -> Void
    
    init(dataService: DataServiceProtocol, user: User?, onRoundCreated: @escaping (Round) -> Void) {
        _viewModel = StateObject(wrappedValue: NewRoundViewModel(dataService: dataService))
        self.user = user
        self.onRoundCreated = onRoundCreated
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Course Name", text: $viewModel.courseName)
                        .textContentType(.organizationName)
                        .accessibilityLabel("Course name")
                } header: {
                    Text("Course Information")
                }
                
                Section {
                    Picker("Number of Holes", selection: $viewModel.holesCount) {
                        Text("9 Holes").tag(9)
                        Text("18 Holes").tag(18)
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("Number of holes")
                } header: {
                    Text("Round Length")
                }
            }
            .navigationTitle("New Round")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Begin Round") {
                        print("🟠 Begin Round button tapped")
                        let round = viewModel.createRound(user: user)
                        print("🟠 Round created, calling onRoundCreated")
                        dismiss()
                        // Small delay to ensure dismiss completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onRoundCreated(round)
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

