//
//  RoundDetailView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI

struct RoundDetailView: View {
    let round: Round
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(round.courseName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(round.startDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Total: \(round.totalStrokes) strokes")
                        Spacer()
                        if round.scoreRelativeToPar != 0 {
                            Text(round.scoreRelativeToPar > 0 ? "+\(round.scoreRelativeToPar)" : "\(round.scoreRelativeToPar)")
                                .foregroundColor(round.scoreRelativeToPar > 0 ? .red : .green)
                        }
                    }
                    .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            
            Section {
                ForEach(round.holes.sorted(by: { $0.holeNumber < $1.holeNumber }), id: \.holeNumber) { hole in
                    HoleDetailRowView(hole: hole)
                }
            } header: {
                Text("Holes")
            }
        }
        .navigationTitle("Round Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HoleDetailRowView: View {
    let hole: Hole
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Hole \(hole.holeNumber)")
                    .font(.headline)
                Spacer()
                Text("Par \(hole.par)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                Label("\(hole.drives)", systemImage: "arrow.up")
                Label("\(hole.longShots)", systemImage: "arrow.up.right")
                Label("\(hole.approaches)", systemImage: "arrow.right")
                Label("\(hole.chips)", systemImage: "arrow.down.right")
                Label("\(hole.putts)", systemImage: "circle")
                Spacer()
                Text("Total: \(hole.totalStrokes)")
                    .fontWeight(.semibold)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

