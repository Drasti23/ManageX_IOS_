

import SwiftUI

struct LogoutView: View {
    var body: some View {
        Button(action: {
            EmployeeManager.clearEmployees()
        }) {
            Text("Log Out")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}


#Preview {
    LogoutView()
}
