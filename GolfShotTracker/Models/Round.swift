//
//  Round.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Round Model
//
//  Represents a complete golf round (9 or 18 holes) played at a specific course.
//  This is a SwiftData @Model that contains all holes played during the round.
//
//  Properties:
//  - id: Unique identifier (UUID) for the round
//  - courseName: Name of the golf course where the round was played
//  - holesCount: Number of holes in the round (9 or 18)
//  - startDate: Date and time when the round started
//  - isDiscarded: Boolean flag for soft delete (hides round from main list)
//  - holes: Array of Hole objects representing each hole in the round
//  - user: Reference to the User who played this round (optional)
//
//  Computed Properties:
//  - totalStrokes: Sum of all strokes across all holes in the round
//  - scoreRelativeToPar: Total score relative to par (positive = over par, negative = under par)
//
//  Relationships:
//  - Has a one-to-many relationship with Hole (cascade delete)
//  - Has an optional relationship with User
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

