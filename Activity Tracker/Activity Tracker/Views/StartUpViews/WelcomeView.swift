//
//  WelcomeView.swift
//  Activity Tracker
//
//  Created by Zayn on 28/02/25.
//

import SwiftUI
import Lottie

struct WelcomeView: View {
    @State private var showLogin = false
    @State private var showSignUp = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background 
                if colorScheme == .light {
                    LottieView(animationName: "backgroundLight")
                        .ignoresSafeArea()
                        .blur(radius: 180)
                } else {
                    LottieView(animationName: "backgroundDark")
                        .ignoresSafeArea()
                        .blur(radius: 180)
                }
                
                VStack {
                    Spacer()
                    
                    // Animated Image 
                    LottieView(animationName: "profileSignUp", loopMode: .loop)
                        .padding(20)
                        .frame(width: 300, height: 300)
                        .clipShape(.circle)
                        .clipped()
                    
                    // App Title
                    Text("Activity Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Text("Your personal activity-tracking assistant")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 40)
                    
                    // Sign Up Button
                    Button {
                        showSignUp = true
                    } label: {
                        Text("Sign Up")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Log In Button
                    Button {
                        showLogin = true
                    } label: {
                        Text("Log In")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    
                    Spacer()
                }
                .padding()
                
                // Full screen covers
                .fullScreenCover(isPresented: $showLogin) {
                    LoginView(viewModel: viewModel)
                }
                .fullScreenCover(isPresented: $showSignUp) {
                    SignUpView(viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
