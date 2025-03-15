//
//  Order.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import Foundation

struct Order {
    var id: String
    var items: [CartItem]
    var totalAmount: Double {
        return items.reduce(into: 0.0) { total, cartItem in
            total += cartItem.item.price * Double(cartItem.quantity)
        }
    }
    var paymentMethod: String
}
