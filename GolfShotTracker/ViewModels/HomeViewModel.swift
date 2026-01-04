//
//  HomeViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Home View Model
//
//  ViewModel for the Home tab that displays the list of completed golf rounds.
//  Manages the state and business logic for the rounds list view.
//
//  Responsibilities:
//  - Load and maintain the list of active (non-discarded) rounds
//  - Sort rounds by date (newest first)
//  - Handle soft deletion of rounds (marking as discarded)
//
//  Published Properties:
//  - rounds: Array of Round objects to display in the list
//
//  Dependencies:
//  - DataServiceProtocol: For fetching and updating rounds
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var rounds: [Round] = []
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadRounds()
    }
    
    func loadRounds() {
        rounds = dataService.fetchRounds(includeDiscarded: false)
            .sorted { $0.startDate > $1.startDate }
    }
    
    func deleteRound(_ round: Round) {
        dataService.markRoundDiscarded(round)
        loadRounds()
    }
}

