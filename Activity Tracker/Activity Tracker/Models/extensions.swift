//
//  extensions.swift
//  Activity Tracker
//
//  Created by Zayn on 22/01/25.
//

import Foundation
import SwiftUI

extension Color {
    static func background(for activityType: String) -> Color {
        switch activityType {
        case "Work":
            return Color.blue.opacity(0.2)
        case "Personal":
            return Color.green.opacity(0.2)
        case "Health":
            return Color.red.opacity(0.2)
        case "Travel":
            return Color.orange.opacity(0.2)
        case "Study":
            return Color.purple.opacity(0.2)
        case "Music":
            return Color.yellow.opacity(0.2)
        case "Movies":
            return Color.gray.opacity(0.2)
        case "Sports":
            return Color.cyan.opacity(0.2)
        case "Reading":
            return Color.brown.opacity(0.2)
        case "Writing":
            return Color.pink.opacity(0.2)
        case "Cooking":
            return Color.teal.opacity(0.2)
        case "Shopping":
            return Color.indigo.opacity(0.2)
        case "Cleaning":
            return Color.clear
        default:
            return Color.blue
        }
    }
    
    static func foreground(for activityType: String) -> Color {
        switch activityType {
        case "Work":
            return Color.blue
        case "Personal":
            return Color.green
        case "Health":
            return Color.red
        case "Travel":
            return Color.orange
        case "Study":
            return Color.purple
        case "Music":
            return Color.yellow
        case "Movies":
            return Color.gray
        case "Sports":
            return Color.cyan
        case "Reading":
            return Color.brown
        case "Writing":
            return Color.pink
        case "Cooking":
            return Color.teal
        case "Shopping":
            return Color.indigo
        case "Cleaning":
            return Color.gray
        default:
            return Color.blue
        }
    }
}

extension String {
    func iconName() -> String {
        switch self {
        case "Work":
            return "briefcase.fill"
        case "Personal":
            return "person.fill"
        case "Health":
            return "heart.fill"
        case "Travel":
            return "airplane"
        case "Study":
            return "book.fill"
        case "Music":
            return "music.note"
        case "Movies":
            return "film.fill"
        case "Sports":
            return "sportscourt"
        case "Reading":
            return "book.closed.fill"
        case "Writing":
            return "pencil"
        case "Cooking":
            return "fork.knife"
        case "Shopping":
            return "cart.fill"
        case "Cleaning":
            return "scalemass"
        default:
            return "questionmark.circle"
        }
    }
}


extension ActivityStore {
    var monthlyActivityCount: Int {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        return activities.filter { activity in
            let activityDate = activity.date 
            return calendar.component(.month, from: activityDate) == currentMonth &&
                   calendar.component(.year, from: activityDate) == currentYear
        }.count
    }
}

extension ActivityStore {
    var recentActivities: [Activity] {
        let sortedActivities = activities.sorted { $0.date > $1.date }
        return Array(sortedActivities.prefix(3)) 
    }
}

