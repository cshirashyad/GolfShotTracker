//
//  StatsSummary.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Statistics Summary
//
//  A value type that aggregates statistics across all completed rounds.
//  Used for displaying lifetime statistics and generating AI-powered practice suggestions.
//
//  Properties:
//  - Aggregated counts for all shot types across all rounds
//  - Total rounds and holes played
//
//  Computed Properties:
//  - Averages: Average shots per hole for each shot type
//  - Percentages: Percentage distribution of each shot type
//  - totalShots: Grand total of all shots across all rounds
//
//  Usage:
//  - Created by SwiftDataService.computeStats()
//  - Consumed by StatsViewModel for display
//  - Passed to AIService for generating practice advice
//

import Foundation

struct StatsSummary {
    var totalRounds: Int
    var totalHoles: Int
    var totalDrives: Int
    var totalLongShots: Int
    var totalApproaches: Int
    var totalChips: Int
    var totalPutts: Int
    var totalFairwayBunkerShots: Int
    var totalGreensideBunkerShots: Int
    var totalPenalties: Int
    
    var totalShots: Int {
        totalDrives + totalLongShots + totalApproaches + totalChips + totalPutts + totalFairwayBunkerShots + totalGreensideBunkerShots + totalPenalties
    }
    
    var averagePuttsPerHole: Double {
        guard totalHoles > 0 else { return 0 }
        return Double(totalPutts) / Double(totalHoles)
    }
    
    var averageDrivesPerHole: Double {
        guard totalHoles > 0 else { return 0 }
        return Double(totalDrives) / Double(totalHoles)
    }
    
    var averageApproachesPerHole: Double {
        guard totalHoles > 0 else { return 0 }
        return Double(totalApproaches) / Double(totalHoles)
    }
    
    var averageChipsPerHole: Double {
        guard totalHoles > 0 else { return 0 }
        return Double(totalChips) / Double(totalHoles)
    }
    
    var drivesPercentage: Double {
        guard totalShots > 0 else { return 0 }
        return (Double(totalDrives) / Double(totalShots)) * 100
    }
    
    var longShotsPercentage: Double {
        guard totalShots > 0 else { return 0 }
        return (Double(totalLongShots) / Double(totalShots)) * 100
    }
    
    var approachesPercentage: Double {
        guard totalShots > 0 else { return 0 }
        return (Double(totalApproaches) / Double(totalShots)) * 100
    }
    
    var chipsPercentage: Double {
        guard totalShots > 0 else { return 0 }
        return (Double(totalChips) / Double(totalShots)) * 100
    }
    
    var puttsPercentage: Double {
        guard totalShots > 0 else { return 0 }
        return (Double(totalPutts) / Double(totalShots)) * 100
    }
}

