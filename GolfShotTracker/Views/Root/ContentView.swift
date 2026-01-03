//
//  ContentView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
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

