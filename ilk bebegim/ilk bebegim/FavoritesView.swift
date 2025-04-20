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
        VStack {
            if favoriteQuestions.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No favorites yet.")
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                Spacer()
            } else {
                List(favoriteQuestions) { question in
                    HStack {
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            Text(question.questionText)
                                .padding(.vertical, 8)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.toggleFavorite(for: question)
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favorites")
    }
}

