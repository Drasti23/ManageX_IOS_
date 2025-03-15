import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                Button(action: {
                    signIn()
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }

                // ✅ Hidden NavigationLink to `HomePageView`
                NavigationLink(destination: HomePageView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
        }
    }

    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty!"
            showError = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }

            print("✅ Login successful")

            // ✅ Properly navigate to `HomePageView`
            DispatchQueue.main.async {
                isLoggedIn = true
            }
        }
    }
}
