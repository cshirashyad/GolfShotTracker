//
//  View+Accessibility.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - View Accessibility Extension
//
//  Provides convenience methods for adding accessibility labels to SwiftUI views.
//  Simplifies VoiceOver support throughout the app.
//
//  Methods:
//  - accessibilityLabel(_:): Sets an accessibility label using a String
//    (convenience wrapper around SwiftUI's Text-based version)
//
//  Usage:
//  - Use when adding VoiceOver support to interactive elements
//  - Ensures all buttons and controls are accessible
//  - Important for users who rely on screen readers
//
//  Note: This is a convenience extension. Most views use the built-in
//  .accessibilityLabel() modifier directly with Text for better localization support.
//

import SwiftUI

extension View {
    func accessibilityLabel(_ label: String) -> some View {
        self.accessibilityLabel(Text(label))
    }
}

