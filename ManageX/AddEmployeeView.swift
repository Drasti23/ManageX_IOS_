//
//  AddEmployeeView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct AddEmployeeView: View {
    @State private var employeeName: String = ""
    @State private var employeeID: String = ""
    @State private var employeeRole: String = ""
    
    var onSave: (Employee) -> Void
    
    var body: some View {
        VStack {
            Text("Add Employee")
                .font(.title)
                .padding()

            TextField("Employee Name", text: $employeeName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Employee ID", text: $employeeID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Employee Role", text: $employeeRole)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if !employeeName.isEmpty && !employeeID.isEmpty && !employeeRole.isEmpty {
                    let newEmployee = Employee(id: employeeID, name: employeeName, role: employeeRole)
                    onSave(newEmployee)
                }
            }) {
                Text("Save Employee")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    AddEmployeeView(onSave: { _ in })
}
