//
//  DataManagementView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

