//
//  SettingsViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    
    private let dataService: DataServiceProtocol
    
    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        isValidEmail(email)
    }
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadUser()
    }
    
    func loadUser() {
        user = dataService.fetchPrimaryUser()
        if let user = user {
            firstName = user.firstName
            lastName = user.lastName
            email = user.email
            phone = user.phone ?? ""
        }
    }
    
    func updateUser() {
        if let existingUser = user {
            existingUser.firstName = firstName.trimmingCharacters(in: .whitespaces)
            existingUser.lastName = lastName.trimmingCharacters(in: .whitespaces)
            existingUser.email = email.trimmingCharacters(in: .whitespaces)
            existingUser.phone = phone.isEmpty ? nil : phone.trimmingCharacters(in: .whitespaces)
            dataService.savePrimaryUser(existingUser)
        } else {
            let newUser = User(
                firstName: firstName.trimmingCharacters(in: .whitespaces),
                lastName: lastName.trimmingCharacters(in: .whitespaces),
                email: email.trimmingCharacters(in: .whitespaces),
                phone: phone.isEmpty ? nil : phone.trimmingCharacters(in: .whitespaces)
            )
            dataService.savePrimaryUser(newUser)
            user = newUser
        }
    }
    
    func hardDeleteDiscardedRounds() {
        dataService.hardDeleteDiscardedRounds()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

