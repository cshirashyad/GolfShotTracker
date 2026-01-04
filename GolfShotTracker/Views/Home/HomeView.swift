//
//  HomeView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Home View
//
//  The main home screen that displays a list of completed golf rounds.
//  This is the primary entry point for viewing past rounds and starting new ones.
//
//  Features:
//  - Displays list of all active (non-discarded) rounds
//  - Empty state with call-to-action when no rounds exist
//  - "New Round" button to start a new round
//  - Tap a round to view details
//  - Swipe to delete (soft delete) rounds
//  - Navigation to round detail view and hole tracker
//
//  Navigation Flow:
//  - New Round button → NewRoundSheetView → HoleTrackerView (full screen)
//  - Tap round → RoundDetailView
//
//  Dependencies:
//  - HomeViewModel: Manages rounds list and deletion
//  - DataServiceProtocol: For data operations
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showNewRoundSheet = false
    @State private var selectedRound: Round?
    @State private var showRoundDetail = false
    @State private var createdRound: Round?
    @State private var showHoleTracker = false
    
    let dataService: DataServiceProtocol
    let user: User?
    
    init(dataService: DataServiceProtocol, user: User?) {
        self.dataService = dataService
        self.user = user
        _viewModel = StateObject(wrappedValue: HomeViewModel(dataService: dataService))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.rounds.isEmpty {
                    emptyStateView
                } else {
                    roundsList
                }
            }
            .navigationTitle("GolfTracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewRoundSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New round")
                }
            }
            .sheet(isPresented: $showNewRoundSheet) {
                NewRoundSheetView(dataService: dataService, user: user) { round in
                    print("🟠 onRoundCreated callback - Round: \(round.courseName), Holes: \(round.holes.count)")
                    // Refresh the round from context to ensure relationships are loaded
                    if let swiftDataService = dataService as? SwiftDataService,
                       let refreshedRound = swiftDataService.fetchRound(byId: round.id) {
                        print("🟠 Refreshed round from context - Holes: \(refreshedRound.holes.count)")
                        createdRound = refreshedRound
                    } else {
                        createdRound = round
                    }
                    print("🟠 Setting showHoleTracker = true")
                    showHoleTracker = true
                }
            }
            .fullScreenCover(isPresented: $showHoleTracker) {
                if let round = createdRound {
                    HoleTrackerView(round: round, dataService: dataService) {
                        viewModel.loadRounds()
                        showHoleTracker = false
                    }
                } else {
                    // Fallback view if round is nil
                    VStack {
                        Text("Error: Round not found")
                            .font(.headline)
                        Button("Close") {
                            showHoleTracker = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationDestination(isPresented: $showRoundDetail) {
                if let round = selectedRound {
                    RoundDetailView(round: round, dataService: dataService)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.golf")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No rounds yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start your first round!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button {
                showNewRoundSheet = true
            } label: {
                Text("New Round")
                    .fontWeight(.semibold)
                    .frame(maxWidth: 200)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var roundsList: some View {
        List {
            ForEach(viewModel.rounds) { round in
                Button {
                    selectedRound = round
                    showRoundDetail = true
                } label: {
                    RoundRowView(round: round)
                }
                .buttonStyle(.plain)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteRound(viewModel.rounds[index])
                }
            }
        }
    }
}

