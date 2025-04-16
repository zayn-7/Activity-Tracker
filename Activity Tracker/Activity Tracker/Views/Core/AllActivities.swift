//
//  AllActivities.swift
//  Activity Tracker
//
//  Created by Zayn on 20/01/25.
//

import SwiftUI
import SwiftData

struct AllActivities: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var activities: [Activity]
    
    @State private var searchText = ""
    @State private var showingAddActivity = false
    @State private var selectedFilter: String? = nil
    @State private var isEditing = false
    
    init() {
        self._activities = Query(
            sort: [
                SortDescriptor(\Activity.date, order: .reverse),
                SortDescriptor(\Activity.title)
            ]
        )
    }
    
    var filteredActivities: [Activity] {
        activities.filter { activity in
            let matchesSearch = searchText.isEmpty ||
                                activity.title.localizedCaseInsensitiveContains(searchText)
            let matchesFilter = selectedFilter == nil || activity.category == selectedFilter
            return matchesSearch && matchesFilter
        }
    }
    
    var uniqueCategories: [String] {
        Array(Set(activities.map { $0.category })).sorted()
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Main content
            VStack(spacing: 0) {
                // Filter pills
                categoryFilterView
                
                // Activities list
                if filteredActivities.isEmpty {
                    emptyStateView
                } else {
                    activitiesList
                }
            }
            
            // Add button
            if !isEditing {
                addButton
            }
        }
        .navigationTitle("Activities")
        .searchable(text: $searchText, prompt: "Search activities")
        .sheet(isPresented: $showingAddActivity) {
            AddNewActivity()
        }
        .animation(.easeInOut(duration: 0.2), value: filteredActivities)
        .animation(.easeInOut(duration: 0.2), value: selectedFilter)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
    
    
    
    //Components
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    selectedFilter = nil
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "square.grid.2x2")
                            .font(.caption)
                        
                        Text("All")
                            .font(.subheadline.weight(.medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(selectedFilter == nil ?
                                  Color.accentColor.opacity(0.9) :
                                    Color(.secondarySystemBackground))
                    )
                    .foregroundColor(selectedFilter == nil ? .white : .primary)
                }
                
                ForEach(uniqueCategories, id: \.self) { category in
                    Button {
                        selectedFilter = category
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: category.iconName())
                                .font(.caption)
                            
                            Text(category)
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(selectedFilter == category ?
                                      Color.foreground(for: category).opacity(0.9) :
                                        Color(.secondarySystemBackground))
                        )
                        .foregroundColor(selectedFilter == category ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
    
    private var activitiesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredActivities) { activity in
                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                        ActivityCard(activity: activity)
                            .contextMenu {
                                Button(role: .destructive) {
                                    withAnimation {
                                        deleteActivity(activity)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                deleteActivity(activity)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "square.stack.3d.up.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(searchText.isEmpty && selectedFilter == nil ?
                 "No Activities Yet" :
                 "No Matching Activities Found")
                .font(.title2.bold())
            
            Text(searchText.isEmpty && selectedFilter == nil ?
                 "Add your first activity with the button below" :
                 "Try changing your search or filters")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    private var addButton: some View {
        Button {
            showingAddActivity = true
        } label: {
            Image(systemName: "plus")
                .font(.title3.weight(.semibold))
                .padding()
                .background(Circle().fill(Color.accentColor))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 30)
    }
    
    private func deleteActivity(_ activity: Activity) {
        modelContext.delete(activity)
        try? modelContext.save()
    }
    
    private func deleteActivity(at offsets: IndexSet) {
        for index in offsets {
            let activity = filteredActivities[index]
            modelContext.delete(activity)
        }
        try? modelContext.save()
    }
}

//Supporting Views

struct ActivityCard: View {
    var activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with category and date
            HStack {
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
                
                Spacer()
                
                Text(activity.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Title
            Text(activity.title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)
            
            // Description preview
            if !activity.descriptions.isEmpty {
                Text(activity.descriptions)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Progress bar
            HStack(spacing: 12) {
                ProgressView(value: min(Double(activity.completionCounts) / 10.0, 1.0))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.foreground(for: activity.category)))
                
                Text("\(activity.completionCounts)")
                    .font(.footnote.monospacedDigit().weight(.medium))
                    .foregroundColor(Color.foreground(for: activity.category))
                    .frame(width: 30)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

//  Preview
struct AllActivities_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllActivities()
        }
    }
}
