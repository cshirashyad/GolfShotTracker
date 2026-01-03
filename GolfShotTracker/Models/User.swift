//
//  User.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

