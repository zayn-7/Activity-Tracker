//
//  SignUpView.swift
//  Activity Tracker
//
//  Created by Zayn on 28/02/25.
//

import SwiftUI
import Lottie

struct SignUpView: View {
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isLoading: Bool = false
    @State private var errorMessage = ""
    @State private var showLogin = false
    
    @ObservedObject var viewModel: AuthViewModel
    
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
                    AuthHeaderView(dismissAction: { dismiss() }, title: "Create Account")
                    
                    ScrollView {
                        VStack(spacing: AppTheme.standardPadding) {
                            // Avatar
                            LottieView(animationName: "profileSignUp", loopMode: .loop)
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                            
                            // Form Fields
                            VStack(spacing: AppTheme.standardPadding) {
                                AppTextField(
                                    title: "Full Name",
                                    placeholder: "Enter your full name",
                                    text: $fullname
                                )
                                
                                AppTextField(
                                    title: "Email",
                                    placeholder: "Enter your email",
                                    text: $email,
                                    keyboardType: .emailAddress
                                )
                                
                                AppTextField(
                                    title: "Password",
                                    placeholder: "Create a password",
                                    text: $password,
                                    isSecureField: true
                                )
                                
                                AppTextField(
                                    title: "Confirm Password",
                                    placeholder: "Confirm your password",
                                    text: $confirmPassword,
                                    isSecureField: true
                                )
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
                            
                            // Sign Up button
                            PrimaryButton(
                                text: "Create Account",
                                action: {
                                    if !email.isEmpty && !password.isEmpty && !fullname.isEmpty && password == confirmPassword {
                                        isLoading = true
                                        Task {
                                            do {
                                                try await viewModel.createUser(withEmail: email, password: password, fullName: fullname)
                                            } catch {
                                                errorMessage = error.localizedDescription
                                            }
                                            isLoading = false
                                        }
                                    } else {
                                        errorMessage = "Please fill in all fields and ensure passwords match."
                                    }
                                },
                                isLoading: isLoading
                            )
                            .padding(.horizontal, AppTheme.standardPadding)
                            .padding(.top, 10)
                            
                            Spacer()
                            
                            // Log In Button
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Button {
                                    dismiss()
                                    showLogin = true
                                } label: {
                                    Text("Log In")
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
            .fullScreenCover(isPresented: $showLogin) {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    SignUpView(viewModel: AuthViewModel())
}
