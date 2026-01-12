//
//  GolfShotTrackerApp.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - App Entry Point
//
//  This is the main entry point for the GolfShotTracker iOS application.
//  It configures the SwiftData model container with the app's data models (User, Round, Hole)
//  and handles database migration for schema changes.
//
//  Key Responsibilities:
//  - Initialize SwiftData ModelContainer with the app's schema
//  - Handle database migrations when new properties are added to models
//  - Provide the root ContentView to the app's WindowGroup
//

import SwiftUI
import SwiftData

@main
struct GolfShotTrackerApp: App {
    // Register your custom AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Round.self,
            Hole.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Migrate existing Hole records to have default values for new properties
            let context = container.mainContext
            let descriptor = FetchDescriptor<Hole>()
            let existingHoles = try? context.fetch(descriptor)
            
            if let holes = existingHoles {
                var needsSave = false
                for hole in holes {
                    // Check if properties need initialization (they might be 0 or uninitialized)
                    // SwiftData should handle this, but we'll ensure they're set
                    if hole.fairwayBunkerShots < 0 {
                        hole.fairwayBunkerShots = 0
                        needsSave = true
                    }
                    if hole.greensideBunkerShots < 0 {
                        hole.greensideBunkerShots = 0
                        needsSave = true
                    }
                    if hole.penalties < 0 {
                        hole.penalties = 0
                        needsSave = true
                    }
                }
                if needsSave {
                    try? context.save()
                }
            }
            
            return container
        } catch {
            // If migration fails, try to delete and recreate (development only)
            print("⚠️ Migration error: \(error)")
            print("⚠️ Attempting to reset database...")
            
            // For development: delete the old store and recreate
            let url = modelConfiguration.url
            try? FileManager.default.removeItem(at: url)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
