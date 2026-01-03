//
//  AIServiceProtocol.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation

protocol AIServiceProtocol {
    func generateAdvice(for stats: StatsSummary) async -> String
}

