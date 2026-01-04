//
//  RoundDetailView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI

struct RoundDetailView: View {
    @StateObject private var viewModel: RoundDetailViewModel
    
    init(round: Round, dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: RoundDetailViewModel(round: round, dataService: dataService))
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.round.courseName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(viewModel.round.startDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Total: \(viewModel.round.totalStrokes) strokes")
                        Spacer()
                        if viewModel.round.scoreRelativeToPar != 0 {
                            Text(viewModel.round.scoreRelativeToPar > 0 ? "+\(viewModel.round.scoreRelativeToPar)" : "\(viewModel.round.scoreRelativeToPar)")
                                .foregroundColor(viewModel.round.scoreRelativeToPar > 0 ? .red : .green)
                        }
                    }
                    .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            
            Section {
                ForEach(viewModel.round.holes.sorted(by: { $0.holeNumber < $1.holeNumber }), id: \.holeNumber) { hole in
                    if viewModel.isEditing {
                        EditableHoleDetailRowView(
                            hole: hole,
                            onUpdate: { drives, longShots, approaches, chips, putts, par in
                                viewModel.updateHole(hole, drives: drives, longShots: longShots, approaches: approaches, chips: chips, putts: putts, par: par)
                                viewModel.refreshRound()
                            }
                        )
                    } else {
                        HoleDetailRowView(hole: hole)
                    }
                }
            } header: {
                Text("Holes")
            }
        }
        .navigationTitle("Round Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(viewModel.isEditing ? "Done" : "Edit") {
                    viewModel.isEditing.toggle()
                }
            }
        }
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

struct EditableHoleDetailRowView: View {
    let hole: Hole
    let onUpdate: (Int, Int, Int, Int, Int, Int) -> Void
    
    @State private var drives: Int
    @State private var longShots: Int
    @State private var approaches: Int
    @State private var chips: Int
    @State private var putts: Int
    @State private var par: Int
    
    init(hole: Hole, onUpdate: @escaping (Int, Int, Int, Int, Int, Int) -> Void) {
        self.hole = hole
        self.onUpdate = onUpdate
        _drives = State(initialValue: hole.drives)
        _longShots = State(initialValue: hole.longShots)
        _approaches = State(initialValue: hole.approaches)
        _chips = State(initialValue: hole.chips)
        _putts = State(initialValue: hole.putts)
        _par = State(initialValue: hole.par)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Hole \(hole.holeNumber)")
                    .font(.headline)
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Par")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Stepper("", value: $par, in: 3...6)
                        .labelsHidden()
                    Text("\(par)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 30)
                }
            }
            
            VStack(spacing: 8) {
                EditableShotRow(title: "Drives", icon: "arrow.up", value: $drives)
                EditableShotRow(title: "Long Shots", icon: "arrow.up.right", value: $longShots)
                EditableShotRow(title: "Approaches", icon: "arrow.right", value: $approaches)
                EditableShotRow(title: "Chips", icon: "arrow.down.right", value: $chips)
                EditableShotRow(title: "Putts", icon: "circle", value: $putts)
            }
            
            HStack {
                Spacer()
                Text("Total: \(drives + longShots + approaches + chips + putts) strokes")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
        .onChange(of: drives) { _, _ in saveChanges() }
        .onChange(of: longShots) { _, _ in saveChanges() }
        .onChange(of: approaches) { _, _ in saveChanges() }
        .onChange(of: chips) { _, _ in saveChanges() }
        .onChange(of: putts) { _, _ in saveChanges() }
        .onChange(of: par) { _, _ in saveChanges() }
    }
    
    private func saveChanges() {
        onUpdate(drives, longShots, approaches, chips, putts, par)
    }
}

struct EditableShotRow: View {
    let title: String
    let icon: String
    @Binding var value: Int
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            Button {
                if value > 0 {
                    value -= 1
                    Haptics.impact(.light)
                }
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(value > 0 ? .red : .gray)
            }
            .buttonStyle(.plain)
            .disabled(value == 0)
            
            TextField("", value: $value, format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .multilineTextAlignment(.center)
                .onChange(of: value) { oldValue, newValue in
                    if newValue < 0 {
                        value = 0
                    }
                }
            
            Button {
                value += 1
                Haptics.impact(.light)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
            .buttonStyle(.plain)
        }
    }
}

