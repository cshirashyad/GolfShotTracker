//
//  HoleTrackerViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Hole Tracker View Model
//
//  ViewModel for tracking shots during an active golf round. This is the core
//  view model that manages shot counting, hole navigation, and round state.
//
//  Responsibilities:
//  - Track current hole and round
//  - Increment/decrement shot counts for all shot types
//  - Navigate between holes (next, previous, jump to specific hole)
//  - Update par for current hole
//  - Calculate round totals and score relative to par
//  - Auto-save all changes to persistence
//
//  Published Properties:
//  - currentRound: The Round being tracked
//  - currentHoleNumber: Current hole number (1-based)
//  - currentHole: The Hole object for the current hole
//
//  Shot Types:
//  - Supports all shot types: drives, long shots, approaches, chips, putts,
//    fairway bunker shots, greenside bunker shots, and penalties
//
//  Dependencies:
//  - DataServiceProtocol: For loading and saving holes
//

import Foundation
import SwiftUI
import Combine

/// Enumeration of all shot types that can be tracked for a hole
enum ShotType {
    case drives
    case longShots
    case approaches
    case chips
    case putts
    case fairwayBunkerShots
    case greensideBunkerShots
    case penalties
}

@MainActor
class HoleTrackerViewModel: ObservableObject {
    @Published var currentRound: Round
    @Published var currentHoleNumber: Int
    @Published var currentHole: Hole?
    
    private let dataService: DataServiceProtocol
    
    var isFirstHole: Bool {
        currentHoleNumber == 1
    }
    
    var isLastHole: Bool {
        currentHoleNumber == currentRound.holesCount
    }
    
    var roundTotalStrokes: Int {
        currentRound.totalStrokes
    }
    
    var roundScoreRelativeToPar: Int {
        currentRound.scoreRelativeToPar
    }
    
    init(round: Round, dataService: DataServiceProtocol) {
        print("🟢 HoleTrackerViewModel init - Round: \(round.courseName), Holes count: \(round.holesCount)")
        print("🟢 Round holes array count: \(round.holes.count)")
        self.currentRound = round
        self.currentHoleNumber = 1
        self.dataService = dataService
        loadHole()
    }
    
    func loadHole() {
        print("🟢 loadHole() called for hole \(currentHoleNumber)")
        print("🟢 Round has \(currentRound.holes.count) holes in array")
        currentHole = dataService.fetchHole(round: currentRound, holeNumber: currentHoleNumber)
        
        if let hole = currentHole {
            print("🟢 Found hole \(currentHoleNumber): par=\(hole.par)")
        } else {
            print("🟡 Hole \(currentHoleNumber) not found, creating...")
            // If hole doesn't exist, create it (shouldn't happen, but safety check)
            if let swiftDataService = dataService as? SwiftDataService {
                // Use the service to create the hole properly
                currentHole = swiftDataService.createHoleIfNeeded(round: currentRound, holeNumber: currentHoleNumber)
                print("🟢 Created hole \(currentHoleNumber)")
            } else {
                // Fallback if we can't cast to SwiftDataService
                let newHole = Hole(holeNumber: currentHoleNumber, par: 4, round: currentRound)
                currentRound.holes.append(newHole)
                dataService.saveHole(newHole)
                currentHole = newHole
                print("🟢 Created hole \(currentHoleNumber) via fallback")
            }
        }
    }
    
    func incrementShot(type: ShotType) {
        guard let hole = currentHole else { return }
        
        switch type {
        case .drives:
            hole.drives += 1
        case .longShots:
            hole.longShots += 1
        case .approaches:
            hole.approaches += 1
        case .chips:
            hole.chips += 1
        case .putts:
            hole.putts += 1
        case .fairwayBunkerShots:
            hole.fairwayBunkerShots += 1
        case .greensideBunkerShots:
            hole.greensideBunkerShots += 1
        case .penalties:
            hole.penalties += 1
        }
        
        dataService.saveHole(hole)
        Haptics.impact(.light)
    }
    
    func decrementShot(type: ShotType) {
        guard let hole = currentHole else { return }
        
        switch type {
        case .drives:
            if hole.drives > 0 {
                hole.drives -= 1
            }
        case .longShots:
            if hole.longShots > 0 {
                hole.longShots -= 1
            }
        case .approaches:
            if hole.approaches > 0 {
                hole.approaches -= 1
            }
        case .chips:
            if hole.chips > 0 {
                hole.chips -= 1
            }
        case .putts:
            if hole.putts > 0 {
                hole.putts -= 1
            }
        case .fairwayBunkerShots:
            if hole.fairwayBunkerShots > 0 {
                hole.fairwayBunkerShots -= 1
            }
        case .greensideBunkerShots:
            if hole.greensideBunkerShots > 0 {
                hole.greensideBunkerShots -= 1
            }
        case .penalties:
            if hole.penalties > 0 {
                hole.penalties -= 1
            }
        }
        
        dataService.saveHole(hole)
        Haptics.impact(.light)
    }
    
    func setPar(_ par: Int) {
        guard let hole = currentHole else { return }
        hole.par = par
        dataService.saveHole(hole)
    }
    
    func goToNextHole() {
        if currentHoleNumber < currentRound.holesCount {
            currentHoleNumber += 1
            loadHole()
        }
    }
    
    func goToPreviousHole() {
        if currentHoleNumber > 1 {
            currentHoleNumber -= 1
            loadHole()
        }
    }
    
    func jumpToHole(_ number: Int) {
        guard number >= 1 && number <= currentRound.holesCount else { return }
        currentHoleNumber = number
        loadHole()
    }
}

