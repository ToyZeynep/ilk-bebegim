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
            VStack(spacing: 0) {
                HStack {
                    Text("Favoriler")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .padding(.top, 16)
                }
                .padding()

                if favoriteQuestions.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.3))
                        Text("Henüz favori yok.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteQuestions) { question in
                                NavigationLink(destination: QuestionDetailView(question: question)) {
                                    QuestionCardView(question: question, viewModel: viewModel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
        }
    }
}
