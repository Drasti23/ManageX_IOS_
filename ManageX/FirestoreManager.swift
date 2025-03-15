//
//  FirestoreManager.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-03-12.
//

import FirebaseFirestore
import Combine

class FirestoreManager: ObservableObject {
    @Published var foodSections: [FoodSection] = []
    @Published var employees: [Employee] = []
    private let db = Firestore.firestore()

    // Fetch Food Sections from Firestore
    func fetchFoodSections() {
        db.collection("foodSections").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("❌ Error fetching sections: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.foodSections = documents.compactMap { doc in
                    let data = doc.data()
                    let items = (data["items"] as? [[String: Any]])?.compactMap { item in
                        return FoodItem(
                            id: item["id"] as? String ?? UUID().uuidString,
                            name: item["name"] as? String ?? "",
                            price: item["price"] as? Double ?? 0.0
                        )
                    } ?? []

                    return FoodSection(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        items: items // ✅ Ensure items are correctly assigned
                    )
                }
            }
        }
    }


    // Add New Food Section to Firestore
    func addFoodSection(name: String) {
        let section = ["name": name, "items": []] as [String: Any]

        db.collection("foodSections").addDocument(data: section) { error in
            if let error = error {
                print("❌ Error adding section: \(error.localizedDescription)")
            }
        }
    }

    // Delete a Food Section from Firestore
    // Delete a Food Section from Firestore
    func deleteFoodSection(sectionId: String) { // ✅ Expect String instead of FoodSection
        db.collection("foodSections").document(sectionId).delete { error in
            if let error = error {
                print("❌ Error deleting section: \(error.localizedDescription)")
            }
        }
    }


    // Add New Item to a Section in Firestore
    func addFoodItem(sectionId: String, item: FoodItem) {
        let sectionRef = db.collection("foodSections").document(sectionId)
        
        sectionRef.updateData([
            "items": FieldValue.arrayUnion([[
                "id": item.id, // ✅ Now uses String
                "name": item.name,
                "price": item.price
            ]])
        ]) { error in
            if let error = error {
                print("❌ Error adding item: \(error.localizedDescription)")
            } else {
                print("✅ Item added successfully to section \(sectionId)")
            }
        }
    }
    
    func addOrder(order: Order) {
        let orderData: [String: Any] = [
            "id": order.id,
            "items": order.items.map { [
                "id": $0.item.id,  // ✅ FIXED: Using `item` instead of `product`
                "name": $0.item.name,
                "price": $0.item.price,
                "quantity": $0.quantity
            ]},
            "totalAmount": order.totalAmount,
            "paymentMethod": order.paymentMethod,
            "timestamp": Timestamp(date: Date()) // Firestore timestamp
        ]
        
        db.collection("orders").document(order.id).setData(orderData) { error in
            if let error = error {
                print("❌ Error saving order: \(error.localizedDescription)")
            } else {
                print("✅ Order successfully saved in Firebase!")
            }
        }
    }
    
    // ✅ Fetch Employees from Firestore
    func fetchEmployees() {
        db.collection("employees").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("❌ Error fetching employees: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.employees = documents.compactMap { doc in
                    let data = doc.data()
                    return Employee(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        role: data["role"] as? String ?? ""
                    )
                }
            }
        }
    }

    // ✅ Add Employee to Firestore
    func addEmployee(_ employee: Employee) {
        let employeeData: [String: Any] = [
            "id": employee.id,
            "name": employee.name,
            "role": employee.role
        ]

        db.collection("employees").document(employee.id).setData(employeeData) { error in
            if let error = error {
                print("❌ Error adding employee: \(error.localizedDescription)")
            } else {
                print("✅ Employee added successfully!")
            }
        }
    }

    // ✅ Delete Employee from Firestore
    func deleteEmployee(employeeId: String) {
        db.collection("employees").document(employeeId).delete { error in
            if let error = error {
                print("❌ Error deleting employee: \(error.localizedDescription)")
            } else {
                print("✅ Employee deleted successfully!")
            }
        }
    }
    
    // ✅ Update Employee in Firestore
    func updateEmployee(_ employee: Employee) {
        let employeeData: [String: Any] = [
            "id": employee.id,
            "name": employee.name,
            "role": employee.role
        ]

        db.collection("employees").document(employee.id).updateData(employeeData) { error in
            if let error = error {
                print("❌ Error updating employee: \(error.localizedDescription)")
            } else {
                print("✅ Employee updated successfully!")
            }
        }
    }
    
    // ✅ Save Clock-in Time
    func logClockIn(employeeId: String, time: Date) {
        let logData: [String: Any] = [
            "employeeId": employeeId,
            "clockIn": Timestamp(date: time)
        ]

        db.collection("timeLogs").document(employeeId).setData(logData) { error in
            if let error = error {
                print("❌ Error logging clock-in: \(error.localizedDescription)")
            } else {
                print("✅ Clock-in logged successfully for employee \(employeeId)")
            }
        }
    }

    // ✅ Save Clock-out Time
    func logClockOut(employeeId: String, time: Date) {
        let clockOutData: [String: Any] = [
            "clockOut": Timestamp(date: time)
        ]

        db.collection("timeLogs").document(employeeId).updateData(clockOutData) { error in
            if let error = error {
                print("❌ Error logging clock-out: \(error.localizedDescription)")
            } else {
                print("✅ Clock-out logged successfully for employee \(employeeId)")
            }
        }
    }
    
    
    func fetchLastClockStatus(employeeId: String, completion: @escaping (Date?, Date?) -> Void) {
        db.collection("timeLogs").document(employeeId).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching clock status: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            if let data = snapshot?.data() {
                let clockInTimestamp = data["clockIn"] as? Timestamp
                let clockOutTimestamp = data["clockOut"] as? Timestamp
                
                let clockInDate = clockInTimestamp?.dateValue()
                let clockOutDate = clockOutTimestamp?.dateValue()
                
                completion(clockInDate, clockOutDate)
            } else {
                completion(nil, nil)
            }
        }
    }





}
