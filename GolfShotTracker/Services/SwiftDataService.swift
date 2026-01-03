//
//  SwiftDataService.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation
import SwiftData

class SwiftDataService: DataServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - User
    
    func fetchPrimaryUser() -> User? {
        let descriptor = FetchDescriptor<User>()
        do {
            let users = try modelContext.fetch(descriptor)
            return users.first
        } catch {
            print("Error fetching primary user: \(error)")
            return nil
        }
    }
    
    func savePrimaryUser(_ user: User) {
        modelContext.insert(user)
        do {
            try modelContext.save()
        } catch {
            print("Error saving primary user: \(error)")
        }
    }
    
    // MARK: - Rounds
    
    func createRound(courseName: String, holesCount: Int, user: User?) -> Round {
        let round = Round(courseName: courseName, holesCount: holesCount, startDate: Date(), user: user)
        
        // Create holes for the round
        for holeNumber in 1...holesCount {
            let hole = Hole(holeNumber: holeNumber, par: 4, round: round)
            round.holes.append(hole)
        }
        
        modelContext.insert(round)
        do {
            try modelContext.save()
        } catch {
            print("Error creating round: \(error)")
        }
        
        return round
    }
    
    func fetchRounds(includeDiscarded: Bool) -> [Round] {
        let descriptor: FetchDescriptor<Round>
        if includeDiscarded {
            descriptor = FetchDescriptor<Round>()
        } else {
            descriptor = FetchDescriptor<Round>(
                predicate: #Predicate<Round> { !$0.isDiscarded }
            )
        }
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching rounds: \(error)")
            return []
        }
    }
    
    func markRoundDiscarded(_ round: Round) {
        round.isDiscarded = true
        do {
            try modelContext.save()
        } catch {
            print("Error marking round as discarded: \(error)")
        }
    }
    
    func hardDeleteDiscardedRounds() {
        let descriptor = FetchDescriptor<Round>(
            predicate: #Predicate<Round> { $0.isDiscarded }
        )
        
        do {
            let discardedRounds = try modelContext.fetch(descriptor)
            for round in discardedRounds {
                modelContext.delete(round)
            }
            try modelContext.save()
        } catch {
            print("Error hard deleting discarded rounds: \(error)")
        }
    }
    
    // MARK: - Holes
    
    func fetchHole(round: Round, holeNumber: Int) -> Hole? {
        return round.holes.first { $0.holeNumber == holeNumber }
    }
    
    func saveHole(_ hole: Hole) {
        do {
            try modelContext.save()
        } catch {
            print("Error saving hole: \(error)")
        }
    }
    
    // MARK: - Stats
    
    func computeStats() -> StatsSummary {
        let rounds = fetchRounds(includeDiscarded: false)
        
        var totalHoles = 0
        var totalDrives = 0
        var totalLongShots = 0
        var totalApproaches = 0
        var totalChips = 0
        var totalPutts = 0
        
        for round in rounds {
            for hole in round.holes {
                totalHoles += 1
                totalDrives += hole.drives
                totalLongShots += hole.longShots
                totalApproaches += hole.approaches
                totalChips += hole.chips
                totalPutts += hole.putts
            }
        }
        
        return StatsSummary(
            totalRounds: rounds.count,
            totalHoles: totalHoles,
            totalDrives: totalDrives,
            totalLongShots: totalLongShots,
            totalApproaches: totalApproaches,
            totalChips: totalChips,
            totalPutts: totalPutts
        )
    }
}

