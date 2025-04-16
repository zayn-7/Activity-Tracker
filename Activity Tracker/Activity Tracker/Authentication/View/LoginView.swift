//
//  LoginView.swift
//  Activity Tracker
//
//  Created by Zayn on 10/03/25.
//

import SwiftUI
import Lottie

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var isLoading: Bool = false
    @State private var errorMessage = ""
    @State private var showSignUp = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if viewModel.userSession != nil {
            HomeView()
        } else {
            ZStack {
                // Background
                BackgroundView()
                
                VStack(spacing: 0) {
                    
                    // Header with back button
                    AuthHeaderView(dismissAction: { dismiss() }, title: "Welcome Back")
                    
                    ScrollView {
                        VStack(spacing: AppTheme.standardPadding) {
                            // Avatar
                            LottieView(animationName: "profileSignUp", loopMode: .loop)
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                            
                            // Form Fields
                            VStack(spacing: AppTheme.standardPadding) {
                                AppTextField(
                                    title: "Email",
                                    placeholder: "Enter your email",
                                    text: $email,
                                    keyboardType: .emailAddress
                                )
                                
                                AppTextField(
                                    title: "Password",
                                    placeholder: "Enter your password",
                                    text: $password,
                                    isSecureField: true
                                )
                                
                                // Forgot Password
                                HStack {
                                    Spacer()
                                    Button {
                                        
                                    } label: {
                                        Text("Forgot Password?")
                                            .font(.subheadline)
                                            .foregroundColor(AppTheme.primaryColor)
                                    }
                                }
                                .padding(.top, -5)
                            }
                            .padding(.horizontal, AppTheme.standardPadding)
                            
                            // Error message
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.footnote.weight(.medium))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, AppTheme.standardPadding)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Login button
                            PrimaryButton(
                                text: "Log In",
                                action: {
                                    if !email.isEmpty && !password.isEmpty {
                                        isLoading = true
                                        Task {
                                            do {
                                                try await viewModel.signIn(email: email, password: password)
                                            } catch {
                                                errorMessage = error.localizedDescription
                                            }
                                            isLoading = false
                                        }
                                    } else {
                                        errorMessage = "Please fill in all fields."
                                    }
                                },
                                isLoading: isLoading
                            )
                            .padding(.horizontal, AppTheme.standardPadding)
                            .padding(.top, 10)
                            
                            Spacer()
                            
                            // Sign Up Button
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Button {
                                    dismiss()
                                    showSignUp = true
                                } label: {
                                    Text("Sign Up")
                                        .fontWeight(.bold)
                                        .foregroundColor(AppTheme.primaryColor)
                                }
                            }
                            .font(.subheadline)
                            .padding(.vertical, 20)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showSignUp) {
                SignUpView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
