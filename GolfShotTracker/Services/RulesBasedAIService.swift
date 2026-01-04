//
//  RulesBasedAIService.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Rules-Based AI Service
//
//  Fallback implementation of AIServiceProtocol that uses rule-based logic
//  to generate practice suggestions from golf statistics.
//
//  Algorithm:
//  - Analyzes shot distribution percentages and averages
//  - Applies predefined rules to identify areas for improvement
//  - Generates actionable suggestions based on statistical patterns
//
//  Rules:
//  - High putt percentage (>40%) or high average putts (>2.5/hole) → putting practice
//  - High chip percentage (>25%) → approach accuracy focus
//  - Low approach percentage (<15%) → distance control work
//  - High drives per hole (>1.2) → tee shot accuracy
//
//  Usage:
//  - Used as fallback when Apple Intelligence is unavailable
//  - Always provides suggestions, even with minimal data
//  - Returns encouraging message if no specific issues detected
//

import Foundation

class RulesBasedAIService: AIServiceProtocol {
    func generateAdvice(for stats: StatsSummary) async -> String {
        guard stats.totalRounds > 0 else {
            return "Start tracking your rounds to receive personalized practice suggestions!"
        }
        
        var suggestions: [String] = []
        
        // Analyze putts
        if stats.puttsPercentage > 40 {
            suggestions.append("Putting accounts for \(String(format: "%.1f", stats.puttsPercentage))% of your shots. Consider allocating more practice time to putting to lower your scores.")
        } else if stats.averagePuttsPerHole > 2.5 {
            suggestions.append("Your average of \(String(format: "%.1f", stats.averagePuttsPerHole)) putts per hole suggests room for improvement on the green.")
        }
        
        // Analyze chips
        if stats.chipsPercentage > 25 {
            suggestions.append("You're taking many chip shots (\(String(format: "%.1f", stats.chipsPercentage))% of total). Focus on approach accuracy to get closer to the pin and reduce chip shots.")
        }
        
        // Analyze approaches
        if stats.approachesPercentage < 15 && stats.totalRounds > 3 {
            suggestions.append("Your approach shots are relatively low. Work on distance control and accuracy from 100 yards and in.")
        }
        
        // Analyze drives
        if stats.averageDrivesPerHole > 1.2 {
            suggestions.append("You're averaging more than one drive per hole. Focus on keeping your tee shots in play to avoid penalty strokes.")
        }
        
        // General encouragement
        if suggestions.isEmpty {
            suggestions.append("Keep up the great work! Your shot distribution looks balanced. Continue practicing all aspects of your game.")
        }
        
        return suggestions.joined(separator: "\n\n")
    }
}

