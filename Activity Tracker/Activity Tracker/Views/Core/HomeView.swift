//
//  ContentView.swift
//  Activity Tracker
//
//  Created by Zayn on 18/02/25.

import SwiftUI
import SwiftData
import Lottie

struct HomeView: View {
    @StateObject var viewModel = AuthViewModel()
    @Query(sort: [SortDescriptor(\Activity.date, order: .reverse), SortDescriptor(\Activity.title)]) private var activities: [Activity]
    
    @State private var showAddActivitySheet = false
    @State private var showProfileView = false
    @State private var showPreviousMonthsSheet = false
    @State private var showChartView = false
    @State private var mothlyActivty = ActivityStore()
    
    // Color theme
    private let accentColor = Color.blue
    private let backgroundColor = Color(.systemBackground)
    private let cardBackgroundColor = Color(.secondarySystemBackground)
    
    var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    // Filter activities for the current month
    var currentMonthActivities: [Activity] {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        return activities.filter { activity in
            let activityMonth = calendar.component(.month, from: activity.date)
            let activityYear = calendar.component(.year, from: activity.date)
            return activityMonth == currentMonth && activityYear == currentYear
        }
    }
    
    // Total completion counts
    var totalCompletionCounts: Int {
        currentMonthActivities.reduce(0) { $0 + $1.completionCounts }
    }
    
    var recentActivities: [Activity] {
        let sortedActivities = activities.sorted { $0.date > $1.date }
        return Array(sortedActivities.prefix(3))
    }
    
    // Reset activities
    func resetActivitiesForNewMonth() {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        for activity in activities {
            let activityMonth = calendar.component(.month, from: activity.date)
            let activityYear = calendar.component(.year, from: activity.date)
            
            if activityMonth != currentMonth || activityYear != currentYear {
                // Reset completion counts
                activity.completionCounts = 0
            }
        }
    }
    
    // default activities for previous months
    func addDefaultActivitiesForPreviousMonths() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        for monthOffset in 1..<6 {
            guard let date = calendar.date(byAdding: .month, value: -monthOffset, to: currentDate) else { continue }
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            let monthName = monthFormatter.string(from: date)
            
            let defaultActivity = Activity(
                category: "Default",
                title: "Activity from \(monthName)",
                completionCounts: 0,
                description: "This is a default activity from a previous month.",
                date: date
            )
            
            //  default activity to the store
            mothlyActivty.activities.append(defaultActivity)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    if activities.isEmpty {
                        
                        // Empty state
                        VStack(spacing: 20) {
                            LottieView(animationName: "noActivity")
                                .frame(height: 350)
                            
                            Text("No activities yet")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text("Tap the + button to add your first activity")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 50)
                    } else {
                        
                        // Completion summary card
                        VStack(spacing: 8) {
                            Text("Completion Count")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text("\(totalCompletionCounts)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(accentColor.opacity(0.8))
                            
                            Text("this month")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(cardBackgroundColor)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        
                        // Recent Activities Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Recent Activities")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                NavigationLink(destination: AllActivities()) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(accentColor)
                                }
                            }
                            
                            if recentActivities.isEmpty {
                                Text("No recent activities")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else {
                                ForEach(recentActivities) { activity in
                                    ActivityRow(activity: activity)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 80)
            }
            .navigationTitle(currentMonthYear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        if !activities.isEmpty {
                            Button {
                                showPreviousMonthsSheet.toggle()
                            } label: {
                                Label("Previous Months", systemImage: "calendar")
                            }
                            
                            NavigationLink {
                                ChartView()
                            } label : {
                                Text("Progress Charts")
                                Image(systemName: "chart.bar.fill")
                            }
                        } else {
                            Button {
                                showPreviousMonthsSheet.toggle()
                            } label: {
                                Label("Previous Months", systemImage: "calendar")
                            }
                        }
                        
                        Button {
                            showProfileView.toggle()
                        } label: {
                            Label("Profile", systemImage: "person.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(accentColor)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                
                // Floating Action Button
                Button {
                    showAddActivitySheet.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 55, height: 55)
                        .background(accentColor)
                        .clipShape(Circle())
                        .shadow(color: accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 25)
            }
        }
        .sheet(isPresented: $showAddActivitySheet) {
            AddNewActivity()
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()
        }
        .sheet(isPresented: $showPreviousMonthsSheet) {
            PreviousMonthsView(activities: mothlyActivty.activities)
        }
        .onAppear {
            Task {
                await viewModel.fetchUser()
            }
            resetActivitiesForNewMonth()
            addDefaultActivitiesForPreviousMonths()
        }
    }
}

// View to display previous months activities
struct PreviousMonthsView: View {
    var activities: [Activity]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { activity in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .font(.headline)
                        
                        HStack {
                            Text(activity.category)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                            
                            Spacer()
                            
                            Text(activity.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Previous Months")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}
