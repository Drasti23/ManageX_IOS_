//
//  EditEmployeeView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct EditEmployeeView: View {
    @Binding var employees: [Employee] // 🔹 Binding to update in parent view
    @State private var employeeName: String
    @State private var employeeRole: String
    @ObservedObject private var firestoreManager = FirestoreManager() // ✅ FirestoreManager

    var employee: Employee
    var onSave: (Employee) -> Void // 🔹 Callback to update parent

    init(employee: Employee, employees: Binding<[Employee]>, onSave: @escaping (Employee) -> Void) {
        _employeeName = State(initialValue: employee.name)
        _employeeRole = State(initialValue: employee.role)
        self.employee = employee
        self._employees = employees
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            Text("Edit Employee")
                .font(.title)
                .padding()

            TextField("Employee Name", text: $employeeName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Employee Role", text: $employeeRole)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                let updatedEmployee = Employee(id: employee.id, name: employeeName, role: employeeRole)
                
                // 🔹 Update Firestore
                firestoreManager.updateEmployee(updatedEmployee)

                // 🔹 Update Local Employees List
                if let index = employees.firstIndex(where: { $0.id == updatedEmployee.id }) {
                    employees[index] = updatedEmployee
                }

                // 🔹 Trigger onSave to update parent view
                onSave(updatedEmployee)
                
            }) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}
