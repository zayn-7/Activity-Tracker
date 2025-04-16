//
//  OnBoardingSlide.swift
//  Activity Tracker
//
//  Created by Zayn on 04/03/25.
//

import Foundation

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

let onboardingSlides: [OnboardingSlide] = [
    OnboardingSlide(
        title: "Track Your Activities",
        description: "Easily log and monitor your daily activities to stay organized.",
        imageName: "checkmark.circle.fill"
    ),
    OnboardingSlide(
        title: "Set Goals",
        description: "Define your goals and track your progress over time.",
        imageName: "target"
    ),
    OnboardingSlide(
        title: "Analyze Your Progress",
        description: "View detailed statistics and charts to understand your performance.",
        imageName: "chart.bar.fill"
    )
]
