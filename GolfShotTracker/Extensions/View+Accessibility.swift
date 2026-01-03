//
//  View+Accessibility.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI

extension View {
    func accessibilityLabel(_ label: String) -> some View {
        self.accessibilityLabel(Text(label))
    }
}

