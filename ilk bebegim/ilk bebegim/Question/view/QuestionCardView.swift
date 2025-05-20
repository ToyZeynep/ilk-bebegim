//
//  QuestionCardView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import SwiftUI

struct QuestionCardView: View {
    let question: Question
    @ObservedObject var viewModel: QuestionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.questionText)
                .font(.headline)
                .foregroundColor(.primary)

            HStack {
                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.toggleFavorite(for: question)
                    }
                }) {
                    Image(systemName: question.isFavorite == true ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
