//
//  OnboardingView.swift
//  Activity Tracker
//
//  Created by Zayn on 28/02/25.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @State private var currentPage = 0
    @State private var showWelcomeView = false
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            
            // Background
            BackgroundView()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    
                    Button {
                        showWelcomeView = true
                    } label: {
                        Text("Skip")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.1))
                            )
                    }
                    .padding(.trailing, AppTheme.standardPadding)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(AppTheme.standardAnimation.delay(0.2), value: isAnimating)
                }
                .padding(.top, 16)
                
                // Page Tab View for Slides
                TabView(selection: $currentPage) {
                    ForEach(onboardingSlides.indices, id: \.self) { index in
                        VStack(spacing: AppTheme.standardPadding) {
                            // Image
                            ZStack {
                                Circle()
                                    .fill(AppTheme.primaryColor.opacity(0.1))
                                    .frame(width: 220, height: 220)
                                
                                Image(systemName: onboardingSlides[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(AppTheme.primaryColor)
                            }
                            .padding(.top, 40)
                            .scaleEffect(isAnimating ? 1 : 0.8)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(AppTheme.standardAnimation, value: isAnimating)
                            
                            VStack(spacing: AppTheme.smallPadding) {
                                // Title
                                Text(onboardingSlides[index].title)
                                    .font(.title.weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .opacity(isAnimating ? 1 : 0)
                                    .animation(AppTheme.standardAnimation.delay(0.2), value: isAnimating)
                                
                                // Description
                                Text(onboardingSlides[index].description)
                                    .font(.body)
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, AppTheme.standardPadding)
                                    .opacity(isAnimating ? 1 : 0)
                                    .animation(AppTheme.standardAnimation.delay(0.4), value: isAnimating)
                            }
                            .padding(.top, 30)
                        }
                        .tag(index)
                        .onAppear {
                            isAnimating = true
                        }
                        .onDisappear {
                            isAnimating = false
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<onboardingSlides.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppTheme.primaryColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.top, 30)
                .opacity(isAnimating ? 1 : 0)
                .animation(AppTheme.standardAnimation.delay(0.6), value: isAnimating)
                
                // Next/Done Button
                Button {
                    if currentPage < onboardingSlides.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                        isAnimating = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isAnimating = true
                        }
                    } else {
                        showWelcomeView = true
                    }
                } label: {
                    Text(currentPage == onboardingSlides.count - 1 ? "Get Started" : "Next")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(height: AppTheme.buttonHeight)
                        .frame(width: 200)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .fill(AppTheme.primaryColor)
                                .shadow(radius: 8, y: 4)
                        )
                }
                .padding(.vertical, 40)
                .opacity(isAnimating ? 1 : 0)
                .animation(AppTheme.standardAnimation.delay(0.8), value: isAnimating)
            }
        }
        .sheet(isPresented: $showWelcomeView) {
            WelcomeView()
        }
    }
}

#Preview {
    OnboardingView()
}
