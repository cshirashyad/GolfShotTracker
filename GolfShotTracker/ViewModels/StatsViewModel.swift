//
//  StatsViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Statistics View Model
//
//  ViewModel for the Statistics tab that displays aggregated golf statistics
//  and AI-powered practice suggestions.
//
//  Responsibilities:
//  - Compute lifetime statistics from all completed rounds
//  - Generate AI-powered practice suggestions based on statistics
//  - Manage loading state during statistics computation
//
//  Published Properties:
//  - statsSummary: Aggregated statistics across all rounds
//  - advice: AI-generated practice suggestions
//  - isLoading: Loading state indicator
//
//  Dependencies:
//  - DataServiceProtocol: For computing statistics
//  - AIServiceProtocol: For generating practice advice
//
//  Usage:
//  - Call loadStats() when the Stats view appears
//  - Statistics are computed synchronously
//  - AI advice is generated asynchronously
//

import Foundation
import SwiftUI
import Combine

@MainActor
class StatsViewModel: ObservableObject {
    @Published var statsSummary: StatsSummary = StatsSummary(
        totalRounds: 0,
        totalHoles: 0,
        totalDrives: 0,
        totalLongShots: 0,
        totalApproaches: 0,
        totalChips: 0,
        totalPutts: 0,
        totalFairwayBunkerShots: 0,
        totalGreensideBunkerShots: 0,
        totalPenalties: 0
    )
    @Published var advice: String = ""
    @Published var isLoading: Bool = false
    
    private let dataService: DataServiceProtocol
    private let aiService: AIServiceProtocol
    
    init(dataService: DataServiceProtocol, aiService: AIServiceProtocol) {
        self.dataService = dataService
        self.aiService = aiService
    }
    
    func loadStats() {
        isLoading = true
        statsSummary = dataService.computeStats()
        
        Task {
            let generatedAdvice = await aiService.generateAdvice(for: statsSummary)
            await MainActor.run {
                self.advice = generatedAdvice
                self.isLoading = false
            }
        }
    }
}

