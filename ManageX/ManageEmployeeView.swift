//
//  ManageEmployeeView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct ManageEmployeeView: View {
    @ObservedObject private var firestoreManager = FirestoreManager() // 🔹 Fetch from Firestore
    @State private var showAlert = false
    @State private var newEmployeeAdded = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(firestoreManager.employees) { employee in
                        HStack {
                            Text(employee.name)
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: EditEmployeeView(
                                employee: employee,
                                employees: $firestoreManager.employees,
                                onSave: { updatedEmployee in
                                    if let index = firestoreManager.employees.firstIndex(where: { $0.id == updatedEmployee.id }) {
                                        firestoreManager.employees[index] = updatedEmployee
                                    }
                                }
                            )) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                NavigationLink(destination: AddEmployeeView(onSave: { newEmployee in
                    firestoreManager.addEmployee(newEmployee) // 🔹 Save to Firestore
                    showAlert = true
                    newEmployeeAdded = true
                }), isActive: $newEmployeeAdded) {
                    Text("Add Employee")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .navigationTitle("Manage Employees")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Employee added successfully."),
                    dismissButton: .default(Text("OK"), action: {
                        newEmployeeAdded = false
                    })
                )
            }
        }
        .onAppear {
            firestoreManager.fetchEmployees() // 🔹 Fetch employees on load
        }
    }
}

#Preview {
    ManageEmployeeView()
}
