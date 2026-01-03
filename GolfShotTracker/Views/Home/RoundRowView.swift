//
//  RoundRowView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI

struct RoundRowView: View {
    let round: Round
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(round.courseName)
                .font(.headline)
            
            HStack {
                Text(round.startDate, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Total: \(round.totalStrokes)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if round.scoreRelativeToPar != 0 {
                    Text(round.scoreRelativeToPar > 0 ? "+\(round.scoreRelativeToPar)" : "\(round.scoreRelativeToPar)")
                        .font(.subheadline)
                        .foregroundColor(round.scoreRelativeToPar > 0 ? .red : .green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

