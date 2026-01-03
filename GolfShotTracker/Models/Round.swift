//
//  Round.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation
import SwiftData

@Model
final class Round {
    @Attribute(.unique) var id: UUID
    var courseName: String
    var holesCount: Int
    var startDate: Date
    var isDiscarded: Bool
    @Relationship(deleteRule: .cascade) var holes: [Hole]
    var user: User?
    
    init(courseName: String, holesCount: Int, startDate: Date, user: User? = nil) {
        self.id = UUID()
        self.courseName = courseName
        self.holesCount = holesCount
        self.startDate = startDate
        self.isDiscarded = false
        self.user = user
        self.holes = []
    }
    
    var totalStrokes: Int {
        holes.reduce(0) { $0 + $1.totalStrokes }
    }
    
    var scoreRelativeToPar: Int {
        let totalPar = holes.reduce(0) { $0 + $1.par }
        return totalStrokes - totalPar
    }
}

