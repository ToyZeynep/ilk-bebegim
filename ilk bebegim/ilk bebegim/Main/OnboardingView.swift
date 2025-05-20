//
//  OnboardingView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct OnboardingView: View {
   @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
   @State private var currentPage = 0

   var body: some View {
       VStack {
           TabView(selection: $currentPage) {
               OnboardingPageView(
                   image: "sparkles",
                   title: "Hoş Geldiniz!",
                   description: "'İlk Bebeğim' bebeğinizle birlikte büyümenize yardımcı olur 🐣."
               )
               .tag(0)

               OnboardingPageView(
                   image: "magnifyingglass",
                   title: "Soruları Keşfedin",
                   description: "Önemli konuları arayın, okuyun ve favorilerinize ekleyin 💡."
               )
               .tag(1)

               OnboardingPageView(
                   image: "heart.fill",
                   title: "Birlikte Büyüyün",
                   description: "Her gün yeni bir şey öğrenin 🍼💖"
               )
               .tag(2)
           }
           .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
           .animation(.easeInOut, value: currentPage)

           if currentPage < 2 {
               Text("Kaydırın veya İleri'ye dokunun →")
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
               Text(currentPage == 2 ? "Başlayın" : "İleri")
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
