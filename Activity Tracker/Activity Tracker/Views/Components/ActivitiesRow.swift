//
//  AcitvityRow.swift
//  Activity Tracker
//
//  Created by Zayn on 21/01/25.
//

import SwiftUI
import SwiftData

struct ActivitiesRow: View {
    @State var activity : Activity
    @State private var showSetReminderSheet = false
    
    var formattedDate : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let date = formatter.string(from: activity.date)
        return date
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.background(for: activity.category))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: activity.category.iconName())
                    }
                
                VStack (spacing: 6){
                    
                    Text(activity.title)
                        .font(.subheadline.bold())
                        .lineLimit(1)
                    
                    Text(activity.category)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack {
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    Text(activity.completionCounts, format: .number)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .bottom], 8)
        }
    }
}

#Preview {
    ActivitiesRow(activity: Activity(category: "aa", title: "bb6erutyhtf ", completionCounts: 0, description: "cc", date: .now))
}
