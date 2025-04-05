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
           
            POSView()
                .tabItem {
                    Label("POS", systemImage: "cart.fill")
                }

            
            ManagerPortalView()  
                .tabItem {
                    Label("Manager Portal", systemImage: "person.3.fill") // Using SF Symbol for Manager Portal
                }

            
            TimeRegisterView()
                .tabItem {
                    Label("Time Register", systemImage: "clock.fill")
                }
        }
        .accentColor(.blue) 
    }
}

#Preview {
    HomePageView()
}
