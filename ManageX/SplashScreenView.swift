//
//  SplashScreenView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        NavigationView {
            ZStack {
                if isActive {
                    SignInView() // ✅ Navigate to SignInView
                } else {
                    VStack {
                        Image(systemName: "cart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)

                        Text("ManageX")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.top, 16)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isActive = true // ✅ Auto-transition to SignInView
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SplashScreenView()
}
