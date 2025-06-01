//
//  QuestionListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct QuestionListView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @State private var searchText: String = ""
    
    var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return viewModel.questions
        } else {
            return viewModel.questions.filter {
                $0.questionText.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
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
                    // Search bar only
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField("Sorularda ara...", text: $searchText)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Content
                    if viewModel.isLoading {
                        Spacer()
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(Color(red: 0.89, green: 0.47, blue: 0.76))
                            Text("Sorular yükleniyor...")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        Spacer()
                    } else if filteredQuestions.isEmpty {
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.gray.opacity(0.4))
                            Text("Soru bulunamadı")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredQuestions) { question in
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
        .onAppear {
            NotificationManager.instance.requestAuthorization()
            NotificationManager.instance.scheduleDailyReminder()
        }
    }
}
