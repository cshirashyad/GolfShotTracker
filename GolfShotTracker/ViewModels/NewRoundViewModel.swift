//
//  NewRoundViewModel.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

