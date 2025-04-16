//
//  ProfileView.swift
//  Activity Tracker
//
//  Created by Zayn on 28/02/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.modelContext) var modelContext
    
    @State private var isLoggedOut: Bool = false
    
    var body: some View {
        
        VStack {
            Button {
                viewModel.signOut()
                isLoggedOut.toggle()
                Task {
                    try modelContext.delete(model: Activity.self)
                    print("Log Out Successfully")
                }
            } label: {
                Text("Log Out")
                    .font(.title2.bold())
                    .foregroundStyle(.red.opacity(0.9))
            }
            .padding(20)
        }
        
        if let user = viewModel.currentUser {
            ZStack {
                
                //Background
                VStack (spacing: 5) {
                    Text(user.initial)
                        .font(.system(size: 52, weight: .bold))
                        .padding(30)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(.circle)
                        .padding()
                    
                    Text(user.fullName)
                        .font(.title.bold())
                    
                    Text(user.email)
                        .font(.title2)
                        .foregroundStyle(.gray)
                    
                    
                    Spacer()
                    
                    Button {
                        viewModel.signOut()
                        isLoggedOut.toggle()
                        Task {
                            try modelContext.delete(model: Activity.self)
                            print("Log Out Successfully")
                        }
                    } label: {
                        Text("Log Out")
                            .font(.title2.bold())
                            .foregroundStyle(.red.opacity(0.9))
                    }
                    .padding(20)
                
                }
                .padding()
                .padding(.top, 150)
            }
            .fullScreenCover(isPresented: $isLoggedOut) {
                WelcomeView()
            }
        }
            
    }
}

#Preview {
    ProfileView()
}
