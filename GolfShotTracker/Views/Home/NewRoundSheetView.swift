//
//  NewRoundSheetView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

