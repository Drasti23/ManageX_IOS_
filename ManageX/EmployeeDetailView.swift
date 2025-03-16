
import SwiftUI

struct EmployeeDetailView: View {
    var employee: Employee
    
    var body: some View {
        VStack {
            Text("Employee Details")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading) {
                Text("Name: \(employee.name)")
                Text("Role: \(employee.role)")
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Employee Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
