//
//  AIServiceProtocol.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - AI Service Protocol
//
//  Defines the interface for generating AI-powered practice suggestions based on
//  golf statistics. This protocol allows for different AI implementations:
//  - Apple Intelligence (when available)
//  - Rules-based fallback
//  - Future: Other on-device or cloud-based LLMs
//
//  Usage:
//  - StatsViewModel uses this to generate practice advice
//  - Takes a StatsSummary and returns human-readable suggestions
//  - All operations are async to support future cloud-based implementations
//

import Foundation

protocol AIServiceProtocol {
    func generateAdvice(for stats: StatsSummary) async -> String
}

