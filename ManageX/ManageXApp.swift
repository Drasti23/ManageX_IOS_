//
//  ManageXApp.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI
import Firebase


@main
struct ManageXApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
