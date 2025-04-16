//
//  ContentView.swift
//  Activity Tracker
//
//  Created by Zayn on 18/02/25.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                HomeView()
                    .environmentObject(viewModel)
            } else {
                OnboardingView()
                    .environmentObject(viewModel)
            }
        }
    }
}
#Preview {
    ContentView()
}
