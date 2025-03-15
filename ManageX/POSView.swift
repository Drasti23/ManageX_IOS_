//
//  POSView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//
import SwiftUI

struct POSView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @ObservedObject private var cartManager = CartManager() // ✅ Cart Manager
    @State private var selectedSection: FoodSection?

    var body: some View {
        NavigationView {
            VStack {
                Text("POS")
                    .font(.largeTitle)
                    .bold()

                // Section Picker
                Picker("Select Section", selection: $selectedSection) {
                    ForEach(firestoreManager.foodSections) { section in
                        Text(section.name).tag(section as FoodSection?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Display Food Items for Selected Section
                if let section = selectedSection {
                    List {
                        ForEach(section.items) { item in
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                                Text("$\(item.price, specifier: "%.2f")")
                                    .foregroundColor(.green)
                                Button(action: {
                                    cartManager.addToCart(item: item) // ✅ Add to Cart
                                }) {
                                    Text("Add to Cart")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } else {
                    Text("Select a section to view items")
                        .foregroundColor(.gray)
                        .padding()
                }

                // Go to Cart Button
                NavigationLink(destination: CartView(cartManager: cartManager)) {
                    Text("View Cart (\(cartManager.cartItems.count))")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .onAppear {
                firestoreManager.fetchFoodSections()
                if let firstSection = firestoreManager.foodSections.first {
                    selectedSection = firstSection
                }
            }
        }
    }
}
