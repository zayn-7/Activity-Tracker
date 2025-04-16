//
//  AppTheme.swift
//  Activity Tracker
//
//  Created by Zayn on 10/03/25.
//

import SwiftUI

//Design Constants
struct AppTheme {
    // Colors
    static let primaryColor = Color.purple
    static let secondaryColor = Color.indigo
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    
    // Dimensions
    static let cornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 56
    static let fieldHeight: CGFloat = 56
    static let standardPadding: CGFloat = 24
    static let smallPadding: CGFloat = 12
    
    // Animations
    static let standardAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.8)
}

// Reusable Components
struct AppTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .none
    var disableAutocorrection: Bool = true
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(AppTheme.textSecondary)
            
            Group {
                if isSecureField {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .autocapitalization(autocapitalization)
                        .disableAutocorrection(disableAutocorrection)
                }
            }
            .padding()
            .frame(height: AppTheme.fieldHeight)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

struct PrimaryButton: View {
    var text: String
    var action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(text)
                        .font(.headline.weight(.bold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppTheme.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppTheme.primaryColor)
                    .shadow(radius: 4, y: 2)
            )
            .foregroundColor(.white)
        }
        .disabled(isLoading)
    }
}

struct SecondaryButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundColor(AppTheme.primaryColor)
                .padding(.vertical, 8)
        }
    }
}

struct BackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            if colorScheme == .light {
                LottieView(animationName: "backgroundLight")
                    .ignoresSafeArea()
                    .blur(radius: 120) 
            } else {
                LottieView(animationName: "backgroundDark")
                    .ignoresSafeArea()
                    .blur(radius: 120)
            }
            
            // Add subtle gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .light ? .white.opacity(0.7) : .black.opacity(0.7),
                    colorScheme == .light ? .white.opacity(0.3) : .black.opacity(0.3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

struct AuthHeaderView: View {
    var dismissAction: () -> Void
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                Button(action: dismissAction) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)
                        .padding()
                        .background(Circle().fill(Color.gray.opacity(0.1)))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Title
            Text(title)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(AppTheme.textPrimary)
                .padding(.top)
                .padding(.horizontal, AppTheme.standardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
