//
//  ChartsView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI
import Charts

struct ChartsView: View {
    let stats: StatsSummary
    
    var body: some View {
        VStack(spacing: 24) {
            // Pie Chart for Shot Distribution
            VStack(alignment: .leading, spacing: 8) {
                Text("Shot Distribution")
                    .font(.headline)
                    .padding(.horizontal)
                
                Chart {
                    SectorMark(
                        angle: .value("Drives", stats.drivesPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.blue)
                    .annotation(position: .overlay) {
                        if stats.drivesPercentage > 5 {
                            Text("\(Int(stats.drivesPercentage))%")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    SectorMark(
                        angle: .value("Long Shots", stats.longShotsPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.green)
                    .annotation(position: .overlay) {
                        if stats.longShotsPercentage > 5 {
                            Text("\(Int(stats.longShotsPercentage))%")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    SectorMark(
                        angle: .value("Approaches", stats.approachesPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.orange)
                    .annotation(position: .overlay) {
                        if stats.approachesPercentage > 5 {
                            Text("\(Int(stats.approachesPercentage))%")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    SectorMark(
                        angle: .value("Chips", stats.chipsPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.purple)
                    .annotation(position: .overlay) {
                        if stats.chipsPercentage > 5 {
                            Text("\(Int(stats.chipsPercentage))%")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    SectorMark(
                        angle: .value("Putts", stats.puttsPercentage),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(.red)
                    .annotation(position: .overlay) {
                        if stats.puttsPercentage > 5 {
                            Text("\(Int(stats.puttsPercentage))%")
                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(height: 200)
                .padding()
                
                // Legend
                VStack(alignment: .leading, spacing: 4) {
                    LegendItem(color: .blue, label: "Drives")
                    LegendItem(color: .green, label: "Long Shots")
                    LegendItem(color: .orange, label: "Approaches")
                    LegendItem(color: .purple, label: "Chips")
                    LegendItem(color: .red, label: "Putts")
                }
                .padding(.horizontal)
            }
            
            // Bar Chart for Averages
            VStack(alignment: .leading, spacing: 8) {
                Text("Average Shots per Hole")
                    .font(.headline)
                    .padding(.horizontal)
                
                Chart {
                    BarMark(x: .value("Type", "Drives"), y: .value("Average", stats.averageDrivesPerHole))
                        .foregroundStyle(.blue)
                    BarMark(x: .value("Type", "Long"), y: .value("Average", Double(stats.totalLongShots) / Double(max(stats.totalHoles, 1))))
                        .foregroundStyle(.green)
                    BarMark(x: .value("Type", "Approach"), y: .value("Average", stats.averageApproachesPerHole))
                        .foregroundStyle(.orange)
                    BarMark(x: .value("Type", "Chips"), y: .value("Average", stats.averageChipsPerHole))
                        .foregroundStyle(.purple)
                    BarMark(x: .value("Type", "Putts"), y: .value("Average", stats.averagePuttsPerHole))
                        .foregroundStyle(.red)
                }
                .frame(height: 200)
                .padding()
            }
        }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .font(.caption)
        }
    }
}

