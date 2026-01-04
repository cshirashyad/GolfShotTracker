//
//  DataManagementView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Data Management View
//
//  A reusable component for data management operations in the Settings view.
//  Provides functionality to permanently delete discarded rounds.
//
//  Features:
//  - "Permanently Delete Discarded Rounds" button
//  - Confirmation alert before deletion
//  - Clear warning about irreversible action
//  - Destructive button styling
//
//  Safety:
//  - Requires explicit confirmation before deletion
//  - Clear messaging about data loss
//  - Only affects soft-deleted (discarded) rounds
//
//  Usage:
//  - Embedded in SettingsView as a section
//  - Uses DataServiceProtocol for deletion operation
//

import SwiftUI

struct DataManagementView: View {
    let dataService: DataServiceProtocol
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        Section {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                HStack {
                    Text("Permanently Delete Discarded Rounds")
                    Spacer()
                }
            }
        } header: {
            Text("Data Management")
        } footer: {
            Text("This will permanently remove all rounds you've discarded. This action cannot be undone.")
        }
        .alert("Delete Discarded Rounds", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                dataService.hardDeleteDiscardedRounds()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to permanently delete all discarded rounds? This action cannot be undone.")
        }
    }
}

