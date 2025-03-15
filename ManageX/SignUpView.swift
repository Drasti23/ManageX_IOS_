//
//  SignUpView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

//
//  SignUpView.swift
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var restaurantName = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var showSuccess = false  // ✅ Show success alert
    @State private var showToast = false    // ✅ Controls the toast visibility

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            TextField("Restaurant Name", text: $restaurantName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }

            Button(action: {
                registerUser()
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationTitle("Create Account")
        .alert(isPresented: $showToast) {  // ✅ Show toast alert
            Alert(title: Text("✅ Success!"),
                  message: Text("Account created successfully! Go back and sign in."),
                  dismissButton: .default(Text("OK")))
        }
    }

    func registerUser() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match!"
            showError = true
            return
        }
        guard !email.isEmpty, !password.isEmpty, !restaurantName.isEmpty else {
            errorMessage = "All fields are required!"
            showError = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    showError = true
                    showSuccess = false // ❌ No success if there's an error
                }
                return
            }

            guard let userID = authResult?.user.uid else { return }

            let db = Firestore.firestore()
            db.collection("users").document(userID).setData([
                "email": email,
                "restaurantName": restaurantName,
                "uid": userID
            ]) { err in
                if let err = err {
                    DispatchQueue.main.async {
                        errorMessage = "Error saving user: \(err.localizedDescription)"
                        showError = true
                        showSuccess = false
                    }
                } else {
                    print("✅ User registered successfully")

                    // ✅ Show Toast Alert & Tell User to Go Back
                    DispatchQueue.main.async {
                        showToast = true
                        showError = false
                    }
                }
            }
        }
    }
}
