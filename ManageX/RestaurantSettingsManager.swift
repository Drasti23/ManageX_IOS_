//
//  RestaurantSettingsManager.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import Foundation

class RestaurantSettingsManager {
    private static let settingsKey = "restaurantSettingsKey"
    
    // Save restaurant settings to UserDefaults
    static func saveSettings(_ settings: RestaurantSettings) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    // Load restaurant settings from UserDefaults
    static func loadSettings() -> RestaurantSettings {
        if let savedData = UserDefaults.standard.data(forKey: settingsKey),
           let decodedSettings = try? JSONDecoder().decode(RestaurantSettings.self, from: savedData) {
            return decodedSettings
        }
        // Return default settings if nothing is saved
        return RestaurantSettings(
            restaurantName: "ABC Restaurant",
            email: "contact@restaurant.com",
            address: "1234 Restaurant St.",
            contactNo: "123-456-7890",
            timings: "9:00 AM - 10:00 PM"
        )
    }
    
    // Clear settings on logout
    static func clearSettings() {
        UserDefaults.standard.removeObject(forKey: settingsKey)
    }
}
