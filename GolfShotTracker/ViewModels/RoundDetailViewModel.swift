//
//  RoundDetailViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Round Detail View Model
//
//  ViewModel for viewing and editing details of a completed golf round.
//  Manages the edit mode state and handles updates to hole scores.
//
//  Responsibilities:
//  - Manage edit mode toggle (view vs edit)
//  - Update hole scores when editing
//  - Validate score inputs (ensure non-negative values)
//  - Refresh round data after updates
//
//  Published Properties:
//  - round: The Round being viewed/edited
//  - isEditing: Boolean flag indicating if edit mode is active
//
//  Features:
//  - Allows editing all shot types for any hole in a completed round
//  - Automatically saves changes to persistence
//  - Validates that all scores are non-negative
//
//  Dependencies:
//  - DataServiceProtocol: For saving hole updates
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RoundDetailViewModel: ObservableObject {
    @Published var round: Round
    @Published var isEditing: Bool = false
    
    private let dataService: DataServiceProtocol
    
    init(round: Round, dataService: DataServiceProtocol) {
        self.round = round
        self.dataService = dataService
    }
    
    func updateHole(_ hole: Hole, drives: Int, longShots: Int, approaches: Int, chips: Int, putts: Int, fairwayBunkerShots: Int, greensideBunkerShots: Int, penalties: Int, par: Int) {
        hole.drives = max(0, drives)
        hole.longShots = max(0, longShots)
        hole.approaches = max(0, approaches)
        hole.chips = max(0, chips)
        hole.putts = max(0, putts)
        hole.fairwayBunkerShots = max(0, fairwayBunkerShots)
        hole.greensideBunkerShots = max(0, greensideBunkerShots)
        hole.penalties = max(0, penalties)
        hole.par = par
        dataService.saveHole(hole)
    }
    
    func refreshRound() {
        // Force a refresh by accessing the round's properties
        objectWillChange.send()
    }
}

