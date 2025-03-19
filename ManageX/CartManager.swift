//
//  Untitled.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-03-14.
//

import Foundation


class CartManager: ObservableObject {
    @Published var cartItems: [CartItem] = []

    func addToCart(item: FoodItem) {
        if let index = cartItems.firstIndex(where: { $0.item.id == item.id }) {
            cartItems[index].quantity += 1
        } else {
            let newItem = CartItem(item: item, quantity: 1)
            cartItems.append(newItem)
        }
        objectWillChange.send() 
    }

    func clearCart() {
        cartItems.removeAll()
        objectWillChange.send() 
    }
    
    func removeFromCart(item: FoodItem) {
        if let index = cartItems.firstIndex(where: { $0.item.id == item.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
        objectWillChange.send() 
    }

    

    var total: Double {
        cartItems.reduce(0) { $0 + ($1.item.price * Double($1.quantity)) }
    }
}
