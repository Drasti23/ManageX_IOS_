
import Foundation

class EmployeeManager {
    private static let employeeKey = "employeeDataKey"
    
    // Save employees to UserDefaults
    static func saveEmployees(_ employees: [Employee]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(employees) {
            UserDefaults.standard.set(encoded, forKey: employeeKey)
        }
    }
    
    // Load employees from UserDefaults
    static func loadEmployees() -> [Employee] {
        if let savedData = UserDefaults.standard.data(forKey: employeeKey),
           let decodedEmployees = try? JSONDecoder().decode([Employee].self, from: savedData) {
            return decodedEmployees
        }
        return []
    }
    
    // Clear employee data on logout
    static func clearEmployees() {
        UserDefaults.standard.removeObject(forKey: employeeKey)
    }
}
