//
//  RoundDetailViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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
    
    func updateHole(_ hole: Hole, drives: Int, longShots: Int, approaches: Int, chips: Int, putts: Int, par: Int) {
        hole.drives = max(0, drives)
        hole.longShots = max(0, longShots)
        hole.approaches = max(0, approaches)
        hole.chips = max(0, chips)
        hole.putts = max(0, putts)
        hole.par = par
        dataService.saveHole(hole)
    }
    
    func refreshRound() {
        // Force a refresh by accessing the round's properties
        objectWillChange.send()
    }
}

