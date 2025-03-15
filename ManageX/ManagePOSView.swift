//
//  ManagePOSView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI
import FirebaseFirestore

struct ManagePOSView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var showAddSection: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if firestoreManager.foodSections.isEmpty {
                    Text("No Food Sections Available")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .padding()
                } else {
                    List {
                        ForEach(firestoreManager.foodSections) { section in
                            if let sectionId = section.id {  // ✅ Unwrap safely
                                NavigationLink(destination: SectionDetailView(sectionId: sectionId, foodSections: $firestoreManager.foodSections)) {
                                    Text(section.name)
                                        .font(.headline)
                                }
                            } else {
                                Text("⚠️ Section ID is missing")
                                    .foregroundColor(.red)
                            }
                        }
                        .onDelete(perform: deleteSection)
                    }
                }

                Button(action: {
                    showAddSection.toggle()
                }) {
                    Label("Add Food Section", systemImage: "plus.circle")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                }
                .sheet(isPresented: $showAddSection) {
                    AddSectionView(foodSections: $firestoreManager.foodSections) { // ✅ Now passing correctly
                        showAddSection = false
                    }
                }
            }
            .navigationTitle("Manage POS")
            .onAppear {
                firestoreManager.fetchFoodSections() // ✅ Fetch data on load
            }
        }
    }

    private func deleteSection(at offsets: IndexSet) {
        offsets.forEach { index in
            let section = firestoreManager.foodSections[index]
            if let sectionId = section.id {  // ✅ Ensure section ID is a valid String
                firestoreManager.deleteFoodSection(sectionId: sectionId) // ✅ Pass String
            } else {
                print("❌ Error: Section ID is nil, cannot delete")
            }
        }
    }
}
