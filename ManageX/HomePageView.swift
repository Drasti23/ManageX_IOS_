//
//  HomePageView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        TabView {
            // POS Tab
            POSView()
                .tabItem {
                    Label("POS", systemImage: "cart.fill") // Using SF Symbol for POS
                }

            // Manager Portal Tab
            ManagerPortalView()  // No need to pass isAuthenticated here
                .tabItem {
                    Label("Manager Portal", systemImage: "person.3.fill") // Using SF Symbol for Manager Portal
                }

            // Time Register Tab
            TimeRegisterView()
                .tabItem {
                    Label("Time Register", systemImage: "clock.fill") // Using SF Symbol for Time Register
                }
        }
        .accentColor(.blue) // Accent color for selected tab item
    }
}

#Preview {
    HomePageView()
}
