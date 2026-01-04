//
//  DataServiceProtocol.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Data Service Protocol
//
//  Defines the interface for data persistence operations in the app.
//  This protocol abstracts away the specific storage implementation, allowing
//  for easy swapping between SwiftData, CloudKit, or other storage backends.
//
//  Responsibilities:
//  - User management (fetch/save primary user)
//  - Round CRUD operations (create, fetch, soft delete, hard delete)
//  - Hole operations (fetch, save)
//  - Statistics computation
//
//  Implementation:
//  - SwiftDataService: Current implementation using SwiftData for local storage
//  - Future: Could add CloudDataService for cloud sync
//

import Foundation

protocol DataServiceProtocol {
    // User
    func fetchPrimaryUser() -> User?
    func savePrimaryUser(_ user: User)
    
    // Rounds
    func createRound(courseName: String, holesCount: Int, user: User?) -> Round
    func fetchRounds(includeDiscarded: Bool) -> [Round]
    func fetchRound(byId id: UUID) -> Round?
    func markRoundDiscarded(_ round: Round)
    func hardDeleteDiscardedRounds()
    
    // Holes
    func fetchHole(round: Round, holeNumber: Int) -> Hole?
    func saveHole(_ hole: Hole)
    
    // Stats
    func computeStats() -> StatsSummary
}

