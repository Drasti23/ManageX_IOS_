//
//  FoodSection.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import Foundation

//struct FoodSection: Identifiable {
//    let id: UUID
//    var name: String
//    var items: [FoodItem]
//
//    init(id: UUID = UUID(), name: String, items: [FoodItem] = []) {
//        self.id = id
//        self.name = name
//        self.items = items
//    }
//}


import Foundation
import FirebaseFirestore

struct FoodSection: Identifiable, Hashable, Codable {
    @DocumentID var id: String? // Firestore auto-generated ID
    var name: String
    var items: [FoodItem]

    init(id: String? = nil, name: String, items: [FoodItem] = []) {
        self.id = id
        self.name = name
        self.items = items
    }

    static func == (lhs: FoodSection, rhs: FoodSection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FoodItem: Identifiable, Hashable, Codable {
    let id: String  // 🔥 Changed from UUID to String
    var name: String
    var price: Double

    init(id: String = UUID().uuidString, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }

    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
