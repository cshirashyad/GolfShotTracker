//
//  DataServiceProtocol.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation

protocol DataServiceProtocol {
    // User
    func fetchPrimaryUser() -> User?
    func savePrimaryUser(_ user: User)
    
    // Rounds
    func createRound(courseName: String, holesCount: Int, user: User?) -> Round
    func fetchRounds(includeDiscarded: Bool) -> [Round]
    func markRoundDiscarded(_ round: Round)
    func hardDeleteDiscardedRounds()
    
    // Holes
    func fetchHole(round: Round, holeNumber: Int) -> Hole?
    func saveHole(_ hole: Hole)
    
    // Stats
    func computeStats() -> StatsSummary
}

