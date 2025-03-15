import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ManagerPortalView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showLogin = true // ✅ Controls login visibility
    @State private var isLoggingOut = false

    var body: some View {
        NavigationStack {
            VStack {
                if isAuthenticated {
                    managerDashboardView
                } else {
                    loginView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarBackButtonHidden(true) // ✅ Prevents unwanted back navigation
        }
    }

    // MARK: - Manager Dashboard (After Login)
    private var managerDashboardView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Welcome, Manager!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.leading, 20)

            // Manager Portal Options
            VStack(spacing: 20) {
                NavigationLink(destination: ManagePOSView()) {
                    ManagerPortalButton(title: "Manage POS", systemImage: "cart.fill")
                }

                NavigationLink(destination: ManageEmployeeView()) {
                    ManagerPortalButton(title: "Manage Employee", systemImage: "person.3.fill")
                }

                NavigationLink(destination: SettingsView()) {
                    ManagerPortalButton(title: "Settings", systemImage: "gearshape.fill")
                }

                // ✅ Logout Button
                Button(action: {
                    logout()
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                        .frame(maxWidth: 300)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, 50)
    }

    // MARK: - Login View (Appears When Pressing "Manager Portal" in Navbar)
    private var loginView: some View {
        VStack {
            Text("Manager Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            TextField("Enter Email", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()
                .frame(maxWidth: 300)

            SecureField("Enter Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(maxWidth: 300)

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }

            Button(action: {
                authenticateManager()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                    .frame(maxWidth: 300)
            }
        }
    }

    // MARK: - Firebase Logout Function
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("❌ Error logging out: \(error.localizedDescription)")
        }
    }

    // MARK: - Firebase Authentication for Manager Login
    func authenticateManager() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty!"
            showError = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    showError = true
                }
                return
            }

            guard let userID = authResult?.user.uid else { return }

            let db = Firestore.firestore()
            db.collection("users").document(userID).getDocument { document, error in
                if let document = document, document.exists {
                    if let userRole = document.data()?["role"] as? String, userRole == "manager" {
                        DispatchQueue.main.async {
                            isAuthenticated = true
                            showError = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            errorMessage = "❌ You are not authorized as a manager."
                            showError = true
                        }
                        logout()
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "❌ Manager not found."
                        showError = true
                    }
                }
            }
        }
    }
}

// MARK: - Custom Button for Manager Portal Options
struct ManagerPortalButton: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.white)
                .font(.title)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

#Preview {
    ManagerPortalView()
}
