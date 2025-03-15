//
//  CartView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartManager: CartManager

    var body: some View {
        VStack {
            Text("Cart")
                .font(.largeTitle)
                .bold()
                .padding()

            if cartManager.cartItems.isEmpty {
                Text("Your cart is empty")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(cartManager.cartItems) { cartItem in
                        HStack {
                            Text(cartItem.item.name)
                                .font(.headline)
                            Spacer()
                            Text("$\(cartItem.item.price, specifier: "%.2f") x \(cartItem.quantity)")
                            
                            Button(action: {
                                cartManager.addToCart(item: cartItem.item)
                            }) {
                                Text("+")
                                    .padding()
                                    .background(Color.green.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            
                            Button(action: {
                                cartManager.removeFromCart(item: cartItem.item)
                            }) {
                                Text("-")
                                    .padding()
                                    .background(Color.red.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                        .onReceive(cartItem.$quantity) { _ in
                            cartManager.objectWillChange.send() // 🔥 Force UI update
                        }
                    }
                }
            }

            Text("Total: $\(cartManager.total, specifier: "%.2f")")
                .font(.title)
                .bold()
                .padding()

            Button(action: {
                checkout()
            }) {
                Text("Checkout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }

    func checkout() {
        print("✅ Checkout successful! Total: $\(String(format: "%.2f", cartManager.total))")
        cartManager.clearCart()
    }
}
