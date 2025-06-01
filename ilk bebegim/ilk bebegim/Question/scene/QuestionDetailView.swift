//
//  QuestionDetailView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct QuestionDetailView: View {
    let question: Question

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.94, blue: 0.96),
                    Color(red: 0.95, green: 0.97, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Question text
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Soru")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        Text(question.questionText)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                    )

                    // Answers section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cevaplar (\(question.answers.count))")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.89, green: 0.47, blue: 0.76),
                                        Color(red: 0.67, green: 0.32, blue: 0.89)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        ForEach(Array(question.answers.enumerated()), id: \.offset) { index, answer in
                            HStack(alignment: .top, spacing: 12) {
                                // Number badge
                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(width: 28, height: 28)
                                    .background(
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.89, green: 0.47, blue: 0.76),
                                                        Color(red: 0.67, green: 0.32, blue: 0.89)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                
                                Text(answer)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.03), radius: 4, y: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle("Detaylar")
        .navigationBarTitleDisplayMode(.inline)
    }
}
