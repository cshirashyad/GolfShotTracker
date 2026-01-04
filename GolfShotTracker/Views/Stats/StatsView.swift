//
//  StatsView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Statistics View
//
//  Displays lifetime golf statistics and AI-powered practice suggestions.
//  This view helps golfers understand their performance patterns and get
//  actionable advice for improvement.
//
//  Features:
//  - Summary statistics cards (rounds, holes, total shots, averages)
//  - Visual charts (pie chart for shot distribution, bar chart for averages)
//  - AI-generated practice suggestions based on statistics
//  - Loading state while computing statistics
//  - Empty state when no rounds have been completed
//
//  Statistics Displayed:
//  - Total rounds and holes played
//  - Total shots by type
//  - Average shots per hole for each type
//  - Percentage distribution of shot types
//
//  Dependencies:
//  - StatsViewModel: Computes statistics and manages AI advice
//  - ChartsView: Displays visual charts
//  - DataServiceProtocol: For fetching statistics
//  - AIServiceProtocol: For generating practice suggestions
//

import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel: StatsViewModel
    
    init(dataService: DataServiceProtocol, aiService: AIServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StatsViewModel(dataService: dataService, aiService: aiService))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.statsSummary.totalRounds == 0 {
                        emptyStateView
                    } else {
                        // Summary Stats
                        VStack(spacing: 16) {
                            HStack(spacing: 20) {
                                StatCard(title: "Rounds", value: "\(viewModel.statsSummary.totalRounds)")
                                StatCard(title: "Holes", value: "\(viewModel.statsSummary.totalHoles)")
                            }
                            
                            HStack(spacing: 20) {
                                StatCard(title: "Total Shots", value: "\(viewModel.statsSummary.totalShots)")
                                StatCard(title: "Avg Putts/Hole", value: String(format: "%.1f", viewModel.statsSummary.averagePuttsPerHole))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Charts
                        ChartsView(stats: viewModel.statsSummary)
                        
                        // AI Advice
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Practice Suggestions")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text(viewModel.advice)
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .onAppear {
                viewModel.loadStats()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Statistics Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Complete a round to see your statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

