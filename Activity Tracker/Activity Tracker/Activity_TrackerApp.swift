//
//  Activity_TrackerApp.swift
//  Activity Tracker
//
//  Created by Zayn on 18/02/25.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct Activity_TrackerApp: App {
    @StateObject var ViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel)
        }
        .modelContainer(for: Activity.self)
    }
}
