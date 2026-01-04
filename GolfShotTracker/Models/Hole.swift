//
//  Hole.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Hole Model
//
//  Represents a single hole in a golf round with detailed shot tracking.
//  This is a SwiftData @Model that stores all shot counts for a specific hole.
//
//  Properties:
//  - holeNumber: The hole number (1-18)
//  - par: The par value for this hole (typically 3, 4, or 5)
//  - drives: Number of tee shots/drives
//  - longShots: Number of long shots (>100 yards, usually second shot on par 5)
//  - approaches: Number of approach shots (inside 100 yards, >15 yards)
//  - chips: Number of chip shots (≤15 yards)
//  - putts: Number of putts
//  - fairwayBunkerShots: Number of shots from fairway bunkers
//  - greensideBunkerShots: Number of shots from greenside bunkers
//  - penalties: Number of penalty strokes
//  - round: Reference to the parent Round
//
//  Computed Properties:
//  - totalStrokes: Sum of all shot types for this hole
//  - scoreRelativeToPar: Score relative to par for this hole
//
//  Relationships:
//  - Belongs to a Round (many-to-one relationship)
//

import Foundation
import SwiftData

@Model
final class Hole {
    var holeNumber: Int
    var par: Int
    var drives: Int
    var longShots: Int
    var approaches: Int
    var chips: Int
    var putts: Int
    var fairwayBunkerShots: Int
    var greensideBunkerShots: Int
    var penalties: Int
    var round: Round?
    
    init(holeNumber: Int, par: Int = 4, round: Round? = nil) {
        self.holeNumber = holeNumber
        self.par = par
        self.drives = 0
        self.longShots = 0
        self.approaches = 0
        self.chips = 0
        self.putts = 0
        self.fairwayBunkerShots = 0
        self.greensideBunkerShots = 0
        self.penalties = 0
        self.round = round
    }
    
    var totalStrokes: Int {
        drives + longShots + approaches + chips + putts + fairwayBunkerShots + greensideBunkerShots + penalties
    }
    
    var scoreRelativeToPar: Int {
        totalStrokes - par
    }
}

