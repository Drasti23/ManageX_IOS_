//
//  CartItem.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//



import Foundation

class CartItem: Identifiable, ObservableObject {
    let id = UUID()
    let item: FoodItem
    @Published var quantity: Int

    init(item: FoodItem, quantity: Int) {
        self.item = item
        self.quantity = quantity
    }
}
