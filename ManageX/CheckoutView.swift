//
//  CheckoutView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cartManager: CartManager
    @State private var paymentMethod = "Cash"
    
    var body: some View {
        VStack {
            Text("Total: $\(String(format: "%.2f", cartManager.total))") // ✅ Fixed formatting
                .font(.title)
                .padding()
            
            Picker("Payment Method", selection: $paymentMethod) {
                Text("Cash").tag("Cash")
                Text("Card").tag("Card")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button(action: completeOrder) {
                Text("Complete Order")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle("Checkout")
    }
    
    func completeOrder() {
        let order = Order(id: UUID().uuidString, items: cartManager.cartItems, paymentMethod: paymentMethod)

        // ✅ Save order to Firebase
        let firestoreManager = FirestoreManager()
        firestoreManager.addOrder(order: order)

        print("✅ Order completed: \(order)")

        // ✅ Clear cart after checkout
        cartManager.clearCart()
    }

}
