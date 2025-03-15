//
//  AddFoodItemView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct AddFoodItemView: View {
    var section: FoodSection
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""

    var body: some View {
        VStack {
            Text("Add Item to \(section.name)")
                .font(.largeTitle)
                .padding()

            TextField("Item Name", text: $itemName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Price ($)", text: $itemPrice)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if let price = Double(itemPrice), !itemName.isEmpty {
                    let newItem = FoodItem(id: UUID().uuidString, name: itemName, price: price)

                    guard let sectionId = section.id else {
                        print("❌ Error: Section ID is nil")
                        return
                    }

                    firestoreManager.addFoodItem(sectionId: sectionId, item: newItem) // ✅ Now sectionId and item.id are both Strings
                }
            }) {
                Text("Add Food Item")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
