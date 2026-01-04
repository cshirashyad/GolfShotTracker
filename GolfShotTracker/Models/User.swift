//
//  User.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - User Model
//
//  Represents the primary user/golfer in the application.
//  This is a SwiftData @Model that stores the user's profile information.
//
//  Properties:
//  - id: Unique identifier (UUID) for the user
//  - firstName: User's first name (required)
//  - lastName: User's last name (required)
//  - email: User's email address (required)
//  - phone: User's mobile number (optional)
//
//  Note: Currently supports a single primary user. Architecture allows for
//  future expansion to support multiple users/players per round.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    
    init(firstName: String, lastName: String, email: String, phone: String? = nil) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
    }
}

