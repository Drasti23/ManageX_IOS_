//
//  AddSectionView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//


import SwiftUI

struct AddSectionView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var sectionName: String = ""
    @Binding var foodSections: [FoodSection] // ✅ Add this
    var onSectionAdded: (() -> Void)?

    init(foodSections: Binding<[FoodSection]>, onSectionAdded: (() -> Void)? = nil) { // ✅ Custom initializer
        self._foodSections = foodSections
        self.onSectionAdded = onSectionAdded
    }

    var body: some View {
        VStack {
            TextField("Enter Food Section Name", text: $sectionName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if !sectionName.isEmpty {
                    firestoreManager.addFoodSection(name: sectionName)
                    onSectionAdded?()
                }
            }) {
                Text("Add Section")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Add Food Section")
    }
}
