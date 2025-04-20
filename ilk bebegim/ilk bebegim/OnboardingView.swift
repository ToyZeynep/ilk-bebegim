//
//  OnboardingView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import SwiftUI

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    image: "sparkles",
                    title: "Welcome!",
                    description: "‘İlk Bebeğim’ helps you grow with your baby 🐣."
                )
                .tag(0)

                OnboardingPageView(
                    image: "magnifyingglass",
                    title: "Explore Questions",
                    description: "Search, read and favorite important topics 💡."
                )
                .tag(1)

                OnboardingPageView(
                    image: "heart.fill",
                    title: "Grow Together",
                    description: "Learn something new every day 🍼💖"
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)

            if currentPage < 2 {
                Text("Swipe or tap Next →")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
            }

            Button(action: {
                if currentPage < 2 {
                    currentPage += 1
                } else {
                    hasSeenOnboarding = true
                }
            }) {
                Text(currentPage == 2 ? "Get Started" : "Next")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}
