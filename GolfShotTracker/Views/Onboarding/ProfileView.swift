//
//  ProfileView.swift
//  GolfShotTracker
//
//  Created by Chandra on 1/3/26.
//
//  MARK: - Profile/Onboarding View
//
//  First-time user onboarding screen that collects basic profile information.
//  This view is shown only on the app's first launch when no user exists.
//
//  Features:
//  - Collects required user information (first name, last name, email)
//  - Optional phone number field
//  - Email format validation
//  - Form validation (save button disabled until valid)
//  - Creates and saves primary user to database
//  - Dismisses to main app after successful save
//
//  Fields:
//  - First Name: Required, text input
//  - Last Name: Required, text input
//  - Email: Required, validated email format
//  - Mobile Number: Optional, phone number input
//
//  Dependencies:
//  - SettingsViewModel: Reused for profile management logic
//  - DataServiceProtocol: For saving user profile
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
            .navigationTitle("Golf Stroke Tracker")
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

