//
//  Haptics+Extensions.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Haptics Extension
//
//  Provides a simple, type-safe API for haptic feedback throughout the app.
//  Wraps UIKit's haptic feedback generators for easy use in SwiftUI views.
//
//  Available Feedback Types:
//  - impact(style:): Tactile feedback for button taps and interactions
//    • Styles: .light, .medium, .heavy
//  - notification(type:): Feedback for notifications and alerts
//    • Types: .success, .warning, .error
//  - selection(): Feedback for selection changes (e.g., picker values)
//
//  Usage:
//  - Call Haptics.impact(.light) when incrementing/decrementing shots
//  - Provides tactile confirmation of user actions
//  - Enhances user experience, especially for on-course use
//

import UIKit

enum Haptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

