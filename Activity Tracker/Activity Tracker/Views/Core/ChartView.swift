//
//  ChartView.swift
//  Activity Tracker
//
//  Created by Zayn on 05/03/25.
//

// this view in completly made with the help of AI

import SwiftUI
import SwiftData
import Charts

struct ChartView: View {
    @Query private var activities: [Activity]
    @State private var selectedCategory: String? = nil
    @State private var selectedFilterOption: FilterOption = .all
    
    enum FilterOption {
        case all
        case individual
    }
    
    // Get the start of the current week
    private var startOfWeek: Date {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = (weekday + 6) % 7 // To make Monday the first day of the week
        return calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
    }
    
    // Get activities from the current week
    private var weeklyActivities: [Activity] {
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        return activities.filter { activity in
            activity.date >= startOfWeek && activity.date <= endOfWeek
        }
    }
    
    // Get categories
    private var uniqueCategories: [String] {
        Array(Set(weeklyActivities.map { $0.category })).sorted()
    }
    
    // Filtered categories based on selection
    private var displayedCategories: [String] {
        switch selectedFilterOption {
        case .all:
            return uniqueCategories
        case .individual:
            if let selected = selectedCategory {
                return [selected]
            } else {
                return uniqueCategories.isEmpty ? [] : [uniqueCategories[0]]
            }
        }
    }
    
    // Group activities by category and day
    private var categoryData: [ChartData] {
        let calendar = Calendar.current
        
        // Create array of 7 days starting from the beginning of the week
        var weekDays: [Date] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                weekDays.append(day)
            }
        }
        
        // Group data by category and day
        var result: [ChartData] = []
        
        for category in displayedCategories {
            var dailyCounts: [DailyCount] = []
            
            for day in weekDays {
                // Get activities for this category and day
                let dayStart = calendar.startOfDay(for: day)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let dayActivities = weeklyActivities.filter { activity in
                    activity.category == category &&
                    activity.date >= dayStart &&
                    activity.date < dayEnd
                }
                
                // Sum completion counts
                let totalCount = dayActivities.reduce(0) { $0 + $1.completionCounts }
                
                dailyCounts.append(DailyCount(date: day, count: totalCount))
            }
            
            result.append(ChartData(category: category, counts: dailyCounts))
        }
        
        return result
    }
    
    // Helper to format dates as day names
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Date range title
                Text(weekRange)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // Filter options
                Picker("View", selection: $selectedFilterOption) {
                    Text("All Categories").tag(FilterOption.all)
                    Text("Single Category").tag(FilterOption.individual)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Category selector (only visible in individual mode)
                if selectedFilterOption == .individual {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(uniqueCategories, id: \.self) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(categoryColorFor(category))
                                            .frame(width: 10, height: 10)
                                        
                                        Text(category)
                                            .font(.caption)
                                    }
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedCategory == category ?
                                                 categoryColorFor(category).opacity(0.2) :
                                                 Color(.systemGray6))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Chart
                ScrollView(.horizontal, showsIndicators: false) {
                    ChartContainer
                        .frame(minWidth: 400, minHeight: 300)
                        .padding(.horizontal)
                }
                
                // Category breakdown
                List {
                    ForEach(categoryData) { category in
                        CategoryBreakdownRow(category: category, dayNameFunction: dayName)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Weekly Progress")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Set default selected category if needed
                if selectedFilterOption == .individual && selectedCategory == nil && !uniqueCategories.isEmpty {
                    selectedCategory = uniqueCategories[0]
                }
            }
            .onChange(of: selectedFilterOption) { _, newValue in
                if newValue == .individual && selectedCategory == nil && !uniqueCategories.isEmpty {
                    selectedCategory = uniqueCategories[0]
                }
            }
        }
    }
    
    private var ChartContainer: some View {
        Chart {
            ForEach(categoryData) { category in
                ForEach(category.counts) { daily in
                    LineMark(
                        x: .value("Day", dayName(for: daily.date)),
                        y: .value("Count", daily.count)
                    )
                    .foregroundStyle(categoryColorFor(category.category))
                    .symbol {
                        Circle()
                            .fill(categoryColorFor(category.category))
                            .frame(width: 8, height: 8)
                    }
                    .interpolationMethod(.catmullRom)
                    
                    // Using AreaMark with opacity instead of PointMark
                    AreaMark(
                        x: .value("Day", dayName(for: daily.date)),
                        y: .value("Count", daily.count)
                    )
                    .foregroundStyle(categoryColorFor(category.category).opacity(0.1))
                }
            }
        }
        .chartLegend(position: .bottom) {
            HStack(spacing: 16) {
                ForEach(categoryData) { category in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(categoryColorFor(category.category))
                            .frame(width: 8, height: 8)
                        
                        Text(category.category)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                AxisGridLine()
            }
        }
    }
    
    // Helper function to get color for a category
    private func categoryColorFor(_ category: String) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .teal, .red, .yellow, .indigo, .cyan]
        
        // Use hash of the string to get a consistent color
        let hash = abs(category.hashValue)
        let index = hash % colors.count
        
        return colors[index]
    }
    
    // Format the week range for display
    private var weekRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
    }
}

// Extracted Category Breakdown Row for better organization
struct CategoryBreakdownRow: View {
    let category: ChartData
    let dayNameFunction: (Date) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category header
            HStack {
                Circle()
                    .fill(categoryColor)
                    .frame(width: 10, height: 10)
                
                Text(category.category)
                    .font(.headline)
                
                Spacer()
                
                let totalCount = category.counts.reduce(0) { $0 + $1.count }
                Text("Total: \(totalCount)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            // Daily breakdown
            HStack {
                ForEach(category.counts) { daily in
                    VStack(spacing: 4) {
                        Text("\(daily.count)")
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.bold)
                        
                        Text(dayNameFunction(daily.date))
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 6)
    }
    
    // Calculate color for this category
    private var categoryColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .teal, .red, .yellow, .indigo, .cyan]
        let hash = abs(category.category.hashValue)
        let index = hash % colors.count
        return colors[index]
    }
}

// Data structures for the chart
struct ChartData: Identifiable {
    var id = UUID()
    var category: String
    var counts: [DailyCount]
}

struct DailyCount: Identifiable {
    var id = UUID()
    var date: Date
    var count: Int
}

#Preview {
    ChartView()
}
