//
//  AppleIntelligenceAIService.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation

class AppleIntelligenceAIService: AIServiceProtocol {
    private let fallbackService: RulesBasedAIService
    
    init() {
        self.fallbackService = RulesBasedAIService()
    }
    
    func generateAdvice(for stats: StatsSummary) async -> String {
        // For MVP, use rules-based service as fallback
        // Future: Integrate Apple Intelligence APIs when available
        // This abstraction allows easy swapping when Apple Intelligence is available
        
        // TODO: When Apple Intelligence APIs are available, implement here
        // For now, use rules-based fallback
        return await fallbackService.generateAdvice(for: stats)
    }
}

