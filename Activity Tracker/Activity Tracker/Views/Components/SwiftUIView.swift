//
//  SwiftUIView.swift
//  Activity Tracker
//
//  Created by Zayn on 06/03/25.
//

import SwiftUI

struct ActivityRow: View {
    var activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.background(for: activity.category).opacity(0.4))
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 5)
                    .overlay {
                        Image(systemName: activity.category.iconName())
                    }
                VStack {
                    Text(activity.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(activity.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.background(for: activity.category).opacity(0.4))
                        .cornerRadius(6)
                }
                Spacer()
                
                VStack(spacing: 5) {
                    Text("\(activity.completionCounts)×")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .offset(y: -4)
                    
                    Text(activity.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .offset(y: 3)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ActivityRow(activity: Activity(category: "aa", title: "bb", completionCounts: 3, description: "ccc", date: .now) )
}
