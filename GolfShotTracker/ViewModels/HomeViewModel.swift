//
//  HomeViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

