//
//  HoleTrackerViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation
import SwiftUI
import Combine

enum ShotType {
    case drives
    case longShots
    case approaches
    case chips
    case putts
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
        self.currentRound = round
        self.currentHoleNumber = 1
        self.dataService = dataService
        loadHole()
    }
    
    func loadHole() {
        currentHole = dataService.fetchHole(round: currentRound, holeNumber: currentHoleNumber)
        
        // If hole doesn't exist, create it (shouldn't happen, but safety check)
        if currentHole == nil, let swiftDataService = dataService as? SwiftDataService {
            // Use the service to create the hole properly
            currentHole = swiftDataService.createHoleIfNeeded(round: currentRound, holeNumber: currentHoleNumber)
        } else if currentHole == nil {
            // Fallback if we can't cast to SwiftDataService
            let newHole = Hole(holeNumber: currentHoleNumber, par: 4, round: currentRound)
            currentRound.holes.append(newHole)
            dataService.saveHole(newHole)
            currentHole = newHole
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

