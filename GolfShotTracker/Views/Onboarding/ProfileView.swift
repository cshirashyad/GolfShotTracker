//
//  ProfileView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: SettingsViewModel
    @Binding var isPresented: Bool
    
    init(dataService: DataServiceProtocol, isPresented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(dataService: dataService))
        _isPresented = isPresented
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
                    Text("Profile Information")
                } footer: {
                    Text("This information helps personalize your golf tracking experience.")
                }
            }
            .navigationTitle("Welcome to GolfTracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save & Continue") {
                        viewModel.updateUser()
                        isPresented = false
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

