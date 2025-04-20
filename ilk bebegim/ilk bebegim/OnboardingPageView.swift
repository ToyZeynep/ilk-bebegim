//
//  OnboardingPageView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import SwiftUI

struct OnboardingPageView: View {
    let image: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundColor(.blue)

            Text(title)
                .font(.title)
                .bold()

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
    }
}
