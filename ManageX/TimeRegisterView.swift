//
//  TimeRegisterView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct TimeRegisterView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var userID: String = ""
    @State private var password: String = "" // 🔹 Optional for authentication
    @State private var isAuthenticated: Bool = false
    @State private var errorMessage: String? = nil
    @State private var authenticatedEmployee: Employee? = nil // ✅ Store authenticated employee

    var body: some View {
        VStack {
            if isAuthenticated, let employee = authenticatedEmployee {
                TimeRegisterMainView(employee: employee)
            } else {
                VStack {
                    Text("Time Register Login")
                        .font(.headline)
                        .padding(.bottom, 20)

                    TextField("Enter Employee ID", text: $userID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.bottom, 10)
                    }

                    Button(action: {
                        authenticateUser()
                    }) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("Time Register")
        .onAppear {
            firestoreManager.fetchEmployees() // ✅ Fetch employees on load
        }
        .navigationBarBackButtonHidden(true) // 🔹 Hide default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigateToPOS()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back to POS")
                    }
                }
            }
        }
    }

    // 🔹 Navigate to POS when Back is pressed
    func navigateToPOS() {
      //
        print("🔙 Navigating back to POS")
    }

    // 🔹 Authenticate user from Firestore
    func authenticateUser() {
        if let employee = firestoreManager.employees.first(where: { $0.id == userID }) {
            authenticatedEmployee = employee
            isAuthenticated = true
            errorMessage = nil
        } else {
            errorMessage = "❌ Invalid Employee ID"
        }
    }
}
