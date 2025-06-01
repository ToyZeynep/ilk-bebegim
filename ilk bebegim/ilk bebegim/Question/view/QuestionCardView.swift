// QuestionCardView.swift

import SwiftUI

struct QuestionCardView: View {
    let question: Question
    @ObservedObject var viewModel: QuestionViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Question content
            VStack(alignment: .leading, spacing: 8) {
                Text(question.questionText)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            
            Spacer()
            
            // Favorite button
            Button(action: {
                viewModel.toggleFavorite(for: question)
            }) {
                Image(systemName: question.isFavorite ?? false ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(question.isFavorite ?? false ? .red : .gray)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: question.isFavorite)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.1),
                            Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1
                )
        )
    }
}
