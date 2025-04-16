//
//  Activity.swift
//  Activity Tracker
//
//  Created by Zayn on 18/02/25.
//

import Foundation
import SwiftData


@Model
class Activity  {
    var id = UUID()
    var category: String
    var title: String
    var completionCounts: Int
    var descriptions: String
    var date: Date
    
    init(id: UUID = UUID(), category: String, title: String, completionCounts: Int, description: String, date: Date) {
        self.id = id
        self.category = category
        self.title = title
        self.completionCounts = completionCounts
        self.descriptions = description
        self.date = date
    }
}

class ActivityStore: ObservableObject {
    var activities: [Activity] = []
}

