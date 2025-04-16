//
//  ActivityDetailView.swift
//  Activity Tracker
//
//  Created by Zayn on 21/01/25.
//

import SwiftUI
import SwiftData

struct ActivityDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var activity: Activity
    
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    
    // Available categories
    let categories: [String] = [
        "Work", "Personal", "Health", "Travel", "Study",
        "Music", "Movies", "Sports", "Reading", "Writing",
        "Cooking", "Shopping", "Cleaning", "Other"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment : .leading, spacing: 24) {
                // Header card
                headerCard
                
                // Details section
                detailsSection
                
                // Category section
                categorySection
                
                // Statistics section
                statsSection
                
                // Action buttons
                actionButtons
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .navigationTitle(isEditing ? "Edit Activity" : activity.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        try? modelContext.save()
                    }
                    isEditing.toggle()
                }
                .fontWeight(.medium)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .alert("Delete Activity", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(activity)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this activity? This action cannot be undone.")
        }
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
    
    // Components
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            if isEditing {
                TextField("Title", text: $activity.title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            } else {
                Text(activity.title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            
            HStack {
                Label("\(activity.date.formatted(date: .abbreviated, time: .shortened))", systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: activity.category.iconName())
                        .font(.caption)
                    
                    Text(activity.category)
                        .font(.caption.weight(.semibold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.background(for: activity.category))
                )
                .foregroundColor(Color.foreground(for: activity.category))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.top)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Details")
                .font(.headline)
                .padding(.leading, 8)
            
            if isEditing {
                TextEditor(text: $activity.descriptions)
                    .font(.body)
                    .frame(minHeight: 120)
                    .overlay {
                        if activity.descriptions.isEmpty {
                            Text("Add Description")
                        }
                    }
            } else {
                Text(activity.descriptions.isEmpty ? "No description provided" : activity.descriptions)
                    .font(.body)
                    .padding()
                    .frame(minHeight: 80, alignment: .topLeading)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text( isEditing ? "Select Category" : "Category")
                .font(.headline)
                .padding(.leading, 8)
            
            if isEditing {
                    Picker("Select Category", selection: $activity.category) {
                        ForEach(categories, id: \.self) { categoryName in
                            HStack {
                                Image(systemName: categoryName.iconName())
                                Text(categoryName)
                            }
                            .tag(categoryName)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.tertiarySystemGroupedBackground))
                    )
            } else {
                HStack {
                    Text("Current category:")
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Image(systemName: activity.category.iconName())
                            .font(.subheadline)
                        
                        Text(activity.category)
                            .font(.subheadline.weight(.medium))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.background(for: activity.category))
                    )
                    .foregroundColor(Color.foreground(for: activity.category))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.tertiarySystemGroupedBackground))
                )
            }
        }
        .padding(.vertical, 8)
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress")
                .font(.headline)
                .padding(.leading, 8)
            
            VStack(spacing: 16) {
                if isEditing {
                    HStack {
                        Text("Completions")
                        Spacer()
                        Stepper("\(activity.completionCounts)", value: $activity.completionCounts, in: 0...100)
                    }
                } else {
                    HStack {
                        Text("Completions")
                        Spacer()
                        Text("\(activity.completionCounts)")
                            .font(.headline)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Progress")
                        Spacer()
                        Text("\(min(activity.completionCounts * 10, 100))%")
                            .font(.subheadline)
                    }
                    
                    ProgressBar(value: min(Double(activity.completionCounts) / 10.0, 1.0), color: Color.foreground(for: activity.category))
                        .frame(height: 8)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemGroupedBackground))
            )
        }
        .padding(.vertical, 8)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            if isEditing {
                Button {
                    try? modelContext.save()
                    isEditing = false
                } label: {
                    Text("Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accentColor)
                        )
                        .foregroundColor(.white)
                }
                
                Button {
                    showingDeleteConfirmation = true
                } label: {
                    Text("Delete Activity")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Supporting Views

struct ProgressBar: View {
    var value: Double 
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                    .cornerRadius(45)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(color)
                    .cornerRadius(45)
                    .animation(.linear, value: value)
            }
        }
    }
}
