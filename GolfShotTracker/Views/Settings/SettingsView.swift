//
//  SettingsView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showSaveConfirmation = false
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        _viewModel = StateObject(wrappedValue: SettingsViewModel(dataService: dataService))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("First Name", text: $viewModel.firstName)
                        .textContentType(.givenName)
                        .accessibilityLabel("First name")
                    
                    TextField("Last Name", text: $viewModel.lastName)
                        .textContentType(.familyName)
                        .accessibilityLabel("Last name")
                    
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .accessibilityLabel("Email")
                    
                    TextField("Mobile Number (Optional)", text: $viewModel.phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        .accessibilityLabel("Mobile number")
                } header: {
                    Text("Profile")
                } footer: {
                    Button {
                        viewModel.updateUser()
                        showSaveConfirmation = true
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.isValid)
                    .padding(.top, 8)
                }
                
                DataManagementView(dataService: dataService)
                
                Section {
                    // Placeholder for future features
                    HStack {
                        Text("Cloud Sync")
                        Spacer()
                        Text("Coming Soon")
                            .foregroundColor(.secondary)
                    }
                    .disabled(true)
                    
                    HStack {
                        Text("Multi-Player Scoring")
                        Spacer()
                        Text("Coming Soon")
                            .foregroundColor(.secondary)
                    }
                    .disabled(true)
                } header: {
                    Text("Future Features")
                }
            }
            .navigationTitle("Settings")
            .alert("Saved", isPresented: $showSaveConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your profile has been updated.")
            }
        }
    }
}

