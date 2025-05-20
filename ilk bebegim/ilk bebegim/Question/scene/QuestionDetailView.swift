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
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cevaplar")
                    .font(.title2)
                    .bold()

                ForEach(question.answers, id: \.self) { answer in
                    Text("• \(answer)")
                        .padding(.vertical, 2)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Soru Detayları")
    }
}
