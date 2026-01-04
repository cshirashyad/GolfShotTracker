//
//  HoleTrackerView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Hole Tracker View
//
//  The primary view for tracking shots during an active golf round.
//  This full-screen view allows golfers to quickly record shots for each hole.
//
//  Features:
//  - Display current hole number and par
//  - Shot counters for all shot types with +/- buttons
//  - Large tap targets for fast on-course entry
//  - Par adjustment (3, 4, 5, or 6)
//  - Navigation between holes (previous, next, jump to hole)
//  - Real-time round totals and score relative to par
//  - End round dialog when completing final hole
//
//  Shot Types Tracked:
//  - Drives, Long Shots, Approaches, Chips, Putts
//  - Fairway Bunker Shots, Greenside Bunker Shots
//  - Penalties
//
//  User Experience:
//  - Haptic feedback on button taps
//  - Auto-saves all changes immediately
//  - Shows loading state if hole data isn't ready
//  - Full-screen presentation for focused tracking
//
//  Dependencies:
//  - HoleTrackerViewModel: Manages shot tracking and navigation
//  - DataServiceProtocol: For persisting shot data
//

import SwiftUI
import SwiftData

struct HoleTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: HoleTrackerViewModel
    @State private var showEndRoundAlert = false
    @State private var showJumpToHoleSheet = false
    let onRoundComplete: () -> Void
    
    init(round: Round, dataService: DataServiceProtocol, onRoundComplete: @escaping () -> Void) {
        print("🟣 HoleTrackerView init - Round: \(round.courseName)")
        _viewModel = StateObject(wrappedValue: HoleTrackerViewModel(round: round, dataService: dataService))
        self.onRoundComplete = onRoundComplete
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Hole \(viewModel.currentHoleNumber) of \(viewModel.currentRound.holesCount)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 8) {
                            Text("Par")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("Par", selection: Binding(
                                get: { viewModel.currentHole?.par ?? 4 },
                                set: { viewModel.setPar($0) }
                            )) {
                                Text("3").tag(3)
                                Text("4").tag(4)
                                Text("5").tag(5)
                                Text("6").tag(6)
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 300)
                        }
                    }
                    .padding(.top)
                    
                    // Shot Counters
                    if let hole = viewModel.currentHole {
                        VStack(spacing: 16) {
                            ShotCounterRowView(
                                title: "Drives",
                                icon: "arrow.up",
                                count: hole.drives,
                                onIncrement: { viewModel.incrementShot(type: .drives) },
                                onDecrement: { viewModel.decrementShot(type: .drives) }
                            )
                            
                            ShotCounterRowView(
                                title: "Long Shots",
                                icon: "arrow.up.right",
                                count: hole.longShots,
                                onIncrement: { viewModel.incrementShot(type: .longShots) },
                                onDecrement: { viewModel.decrementShot(type: .longShots) }
                            )
                            
                            ShotCounterRowView(
                                title: "Approaches",
                                icon: "arrow.right",
                                count: hole.approaches,
                                onIncrement: { viewModel.incrementShot(type: .approaches) },
                                onDecrement: { viewModel.decrementShot(type: .approaches) }
                            )
                            
                            ShotCounterRowView(
                                title: "Chips",
                                icon: "arrow.down.right",
                                count: hole.chips,
                                onIncrement: { viewModel.incrementShot(type: .chips) },
                                onDecrement: { viewModel.decrementShot(type: .chips) }
                            )
                            
                            ShotCounterRowView(
                                title: "Putts",
                                icon: "circle",
                                count: hole.putts,
                                onIncrement: { viewModel.incrementShot(type: .putts) },
                                onDecrement: { viewModel.decrementShot(type: .putts) }
                            )
                            
                            ShotCounterRowView(
                                title: "Fairway Bunker",
                                icon: "square.fill",
                                count: hole.fairwayBunkerShots,
                                onIncrement: { viewModel.incrementShot(type: .fairwayBunkerShots) },
                                onDecrement: { viewModel.decrementShot(type: .fairwayBunkerShots) }
                            )
                            
                            ShotCounterRowView(
                                title: "Greenside Bunker",
                                icon: "square.fill",
                                count: hole.greensideBunkerShots,
                                onIncrement: { viewModel.incrementShot(type: .greensideBunkerShots) },
                                onDecrement: { viewModel.decrementShot(type: .greensideBunkerShots) }
                            )
                            
                            ShotCounterRowView(
                                title: "Penalties",
                                icon: "exclamationmark.triangle.fill",
                                count: hole.penalties,
                                onIncrement: { viewModel.incrementShot(type: .penalties) },
                                onDecrement: { viewModel.decrementShot(type: .penalties) }
                            )
                        }
                        .padding(.horizontal)
                        
                        // Summary
                        VStack(spacing: 8) {
                            Text("Hole Total: \(hole.totalStrokes) strokes")
                                .font(.headline)
                            
                            Text("Round Total: \(viewModel.roundTotalStrokes) strokes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if viewModel.roundScoreRelativeToPar != 0 {
                                Text(viewModel.roundScoreRelativeToPar > 0 ? "+\(viewModel.roundScoreRelativeToPar) over par" : "\(viewModel.roundScoreRelativeToPar) under par")
                                    .font(.subheadline)
                                    .foregroundColor(viewModel.roundScoreRelativeToPar > 0 ? .red : .green)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        // Loading or error state
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Loading hole data...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                print("🟣 HoleTrackerView onAppear")
                print("🟣 Current hole: \(viewModel.currentHole == nil ? "nil" : "exists")")
                // Ensure hole is loaded when view appears
                if viewModel.currentHole == nil {
                    print("🟣 Loading hole...")
                    viewModel.loadHole()
                }
            }
            .navigationTitle(viewModel.currentRound.courseName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showJumpToHoleSheet = true
                    } label: {
                        Image(systemName: "list.number")
                    }
                    .accessibilityLabel("Jump to hole")
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        viewModel.goToPreviousHole()
                    } label: {
                        Label("Previous", systemImage: "chevron.left")
                    }
                    .disabled(viewModel.isFirstHole)
                    
                    Spacer()
                    
                    Button {
                        if viewModel.isLastHole {
                            showEndRoundAlert = true
                        } else {
                            viewModel.goToNextHole()
                        }
                    } label: {
                        Label(viewModel.isLastHole ? "End Round" : "Next", systemImage: "chevron.right")
                    }
                }
            }
            .sheet(isPresented: $showJumpToHoleSheet) {
                JumpToHoleSheetView(totalHoles: viewModel.currentRound.holesCount) { holeNumber in
                    viewModel.jumpToHole(holeNumber)
                }
            }
            .alert("Round Completed", isPresented: $showEndRoundAlert) {
                Button("Save Round", role: .none) {
                    onRoundComplete()
                }
                Button("Discard Round", role: .destructive) {
                    // Mark as discarded
                    viewModel.currentRound.isDiscarded = true
                    onRoundComplete()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("What would you like to do with this round?")
            }
        }
    }
}

