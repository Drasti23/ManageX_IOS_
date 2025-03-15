//
//  SectionDetailView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct SectionDetailView: View {
    let sectionId: String // 🔥 Change from UUID to String
    @Binding var foodSections: [FoodSection]
    @State private var isShowingAddItem = false

    var body: some View {
        if let section = foodSections.first(where: { $0.id == sectionId }) { // 🔥 Compare with String now
            VStack {
                Text("Items in \(section.name)")
                    .font(.largeTitle)
                    .padding()

                List {
                    ForEach(section.items) { item in
                        HStack {
                            Text(item.name)
                                .font(.subheadline)
                            Spacer()
                            Text(String(format: "$%.2f", item.price))
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                }
                .onAppear {
                    print("Section items in \(section.name): \(section.items)")
                }

                NavigationLink(destination: AddFoodItemView(section: section), isActive: $isShowingAddItem) {
                    EmptyView()
                }
                .hidden()

                Button(action: {
                    isShowingAddItem = true
                }) {
                    Text("Add Item")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("\(section.name) Items")
            .onReceive(foodSections.publisher.collect()) { _ in
                print("foodSections changed")
            }
        } else {
            Text("Section not found")
                .font(.largeTitle)
                .padding()
        }
    }
}
