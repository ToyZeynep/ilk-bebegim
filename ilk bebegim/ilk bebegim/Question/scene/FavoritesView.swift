//
//  FavoritesView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: QuestionViewModel

    var favoriteQuestions: [Question] {
        viewModel.questions.filter { $0.isFavorite == true }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.94, blue: 0.96),
                        Color(red: 0.95, green: 0.97, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if favoriteQuestions.isEmpty {
                        Spacer()
                        VStack(spacing: 24) {
                            Image(systemName: "heart.slash.fill")
                                .font(.system(size: 72))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            VStack(spacing: 8) {
                                Text("Henüz favori yok")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                Text("İstediğin soruları favorilere ekleyerek\nburadan kolayca erişebilirsin")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(favoriteQuestions) { question in
                                    NavigationLink(destination: QuestionDetailView(question: question)) {
                                        QuestionCardView(question: question, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
        }
    }
}
