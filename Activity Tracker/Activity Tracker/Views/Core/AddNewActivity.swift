//
//  AddNewActivity.swift
//  Activity Tracker
//
//  Created by Zayn on 21/01/25.
//

import SwiftUI
import SwiftData

struct AddNewActivity: View {
    // Form inputs
    @State private var activityName: String = ""
    @State private var completionCounts: Int = 1
    @State private var description: String = ""
    @State private var category: String = "Work"
    
    // Available categories
    let categories: [String] = [
        "Work", "Personal", "Health", "Travel", "Study",
        "Music", "Movies", "Sports", "Reading", "Writing",
        "Cooking", "Shopping", "Cleaning", "Other"
    ]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showCategoryPicker = false
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Category selection
                        categorySelectionView
                        
                        // Basic details card
                        basicDetailsCard
                        
                        // Description card
                        descriptionCard
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            
            // Add button
            VStack {
                Spacer()
                addButton
            }
            .ignoresSafeArea(.keyboard)
        }
        .sheet(isPresented: $showCategoryPicker) {
            categoryPickerSheet
        }
    }
    
    // Components
    
    private var headerView: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.secondary)
            
            Spacer()
            
            Text("New Activity")
                .font(.headline)
            
            Spacer()
            
            Button("Cancel") {
                
            }
            .opacity(0)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
    }
    
    private var categorySelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
                .padding(.leading, 8)
            
            Button {
                showCategoryPicker = true
            } label: {
                HStack {
                    categoryBadge(for: category)
                        .padding(.vertical, 4)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.top)
    }
    
    private var basicDetailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
                .padding(.leading, 8)
            
            VStack(spacing: 0) {
                // Activity name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activity Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter activity name", text: $activityName)
                        .font(.body)
                }
                .padding()
                
                Divider()
                    .padding(.horizontal)
                
                // Completion count
                VStack(alignment: .leading, spacing: 8) {
                    Text("Completion Goal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("\(completionCounts)")
                            .font(.title3.monospacedDigit())
                            .frame(width: 40, alignment: .center)
                        
                        Stepper("", value: $completionCounts, in: 1...100)
                            .labelsHidden()
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.headline)
                .padding(.leading, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                TextEditor(text: $description)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .placeholder(when: description.isEmpty) {
                        Text("Enter activity description...")
                            .foregroundColor(.secondary)
                            .padding(.leading, 5)
                            .padding(.top, 8)
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
    }
    
    private var addButton: some View {
        Button {
            addActivity()
        } label: {
            Text("Add Activity")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isFormValid ? Color.accentColor : Color.gray)
                )
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .disabled(!isFormValid)
        .background(
            Rectangle()
                .fill(Color(.systemGroupedBackground))
                .frame(height: 100)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }
    
    private var categoryPickerSheet: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { categoryName in
                    Button {
                        category = categoryName
                        showCategoryPicker = false
                    } label: {
                        HStack {
                            Image(systemName: categoryName.iconName())
                                .foregroundColor(Color.foreground(for: categoryName))
                                .frame(width: 24, height: 24)
                            
                            Text(categoryName)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if category == categoryName {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showCategoryPicker = false
                    }
                }
            }
        }
    }
    
    // Helper Methods
    
    private func categoryBadge(for categoryName: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: categoryName.iconName())
                .font(.subheadline)
            
            Text(categoryName)
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.background(for: categoryName))
        )
        .foregroundColor(Color.foreground(for: categoryName))
    }
    
    private var isFormValid: Bool {
        !activityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func addActivity() {
        let newActivity = Activity(category: category, title: activityName, completionCounts: completionCounts, description: description, date: .now)
        
        modelContext.insert(newActivity)
        try? modelContext.save()
        dismiss()
    }
}

// Extensions

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct AddNewActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddNewActivity()
    }
}


