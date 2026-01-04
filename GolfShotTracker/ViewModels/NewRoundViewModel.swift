//
//  NewRoundViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - New Round View Model
//
//  ViewModel for creating a new golf round. Manages the form state and validation
//  for the new round creation sheet.
//
//  Responsibilities:
//  - Manage course name input
//  - Manage holes count selection (9 or 18)
//  - Validate form input
//  - Create new Round with all associated Holes
//
//  Published Properties:
//  - courseName: User-entered course name
//  - holesCount: Selected number of holes (default: 18)
//
//  Validation:
//  - isValid: Returns true if course name is not empty
//

import Foundation
import SwiftUI
import Combine

@MainActor
class NewRoundViewModel: ObservableObject {
    @Published var courseName: String = ""
    @Published var holesCount: Int = 18
    
    private let dataService: DataServiceProtocol
    
    var isValid: Bool {
        !courseName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func createRound(user: User?) -> Round {
        return dataService.createRound(
            courseName: courseName.trimmingCharacters(in: .whitespaces),
            holesCount: holesCount,
            user: user
        )
    }
}

