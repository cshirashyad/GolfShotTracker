//
//  Hole.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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
    var round: Round?
    
    init(holeNumber: Int, par: Int = 4, round: Round? = nil) {
        self.holeNumber = holeNumber
        self.par = par
        self.drives = 0
        self.longShots = 0
        self.approaches = 0
        self.chips = 0
        self.putts = 0
        self.round = round
    }
    
    var totalStrokes: Int {
        drives + longShots + approaches + chips + putts
    }
    
    var scoreRelativeToPar: Int {
        totalStrokes - par
    }
}

