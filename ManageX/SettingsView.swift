//
//  SettingsView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct SettingsView: View {
    @State private var restaurantName: String
    @State private var email: String
    @State private var address: String
    @State private var contactNo: String
    @State private var timings: String
    
    // Initialize with saved settings or default values
    init() {
        let settings = RestaurantSettingsManager.loadSettings()
        _restaurantName = State(initialValue: settings.restaurantName)
        _email = State(initialValue: settings.email)
        _address = State(initialValue: settings.address)
        _contactNo = State(initialValue: settings.contactNo)
        _timings = State(initialValue: settings.timings)
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Restaurant Information")) {
                    // Non-editable fields
                    HStack {
                        Text("Restaurant Name")
                        Spacer()
                        Text(restaurantName)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(email)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Editable Information")) {
                    // Editable fields
                    TextField("Address", text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Contact No", text: $contactNo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Timings", text: $timings)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: {
                    saveSettings()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func saveSettings() {
        let updatedSettings = RestaurantSettings(
            restaurantName: restaurantName,
            email: email,
            address: address,
            contactNo: contactNo,
            timings: timings
        )
        RestaurantSettingsManager.saveSettings(updatedSettings)
    }
}
