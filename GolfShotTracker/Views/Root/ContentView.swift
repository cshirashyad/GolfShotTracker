//
//  ContentView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Root Content View
//
//  The root view of the application that manages the overall navigation structure
//  and service initialization. This view determines whether to show onboarding
//  or the main app interface.
//
//  Responsibilities:
//  - Initialize data service and AI service
//  - Check if user has completed onboarding
//  - Display onboarding (ProfileView) for first-time users
//  - Display main TabView (Home, Stats, Settings) for returning users
//
//  Navigation Structure:
//  - Onboarding → ProfileView (first launch only)
//  - Main App → TabView with three tabs:
//    • Home: Rounds list and new round creation
//    - Stats: Statistics and practice suggestions
//    - Settings: Profile and data management
//
//  Dependencies:
//  - SwiftData ModelContext: For data persistence
//  - SwiftDataService: Concrete data service implementation
//  - AppleIntelligenceAIService: AI service for practice suggestions
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var dataService: SwiftDataService?
    @State private var aiService: AIServiceProtocol = AppleIntelligenceAIService()
    @State private var user: User?
    @State private var showOnboarding = false
    
    var body: some View {
        Group {
            if let dataService = dataService {
                if showOnboarding {
                    ProfileView(dataService: dataService, isPresented: $showOnboarding)
                        .onDisappear {
                            user = dataService.fetchPrimaryUser()
                        }
                } else {
                    TabView {
                        HomeView(dataService: dataService, user: user)
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                        
                        StatsView(dataService: dataService, aiService: aiService)
                            .tabItem {
                                Label("Stats", systemImage: "chart.bar.fill")
                            }
                        
                        SettingsView(dataService: dataService)
                            .tabItem {
                                Label("Settings", systemImage: "gearshape.fill")
                            }
                    }
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            setupServices()
            checkOnboarding()
        }
    }
    
    private func setupServices() {
        if dataService == nil {
            dataService = SwiftDataService(modelContext: modelContext)
        }
    }
    
    private func checkOnboarding() {
        guard let dataService = dataService else { return }
        user = dataService.fetchPrimaryUser()
        showOnboarding = user == nil
    }
}

