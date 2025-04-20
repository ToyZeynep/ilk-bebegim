//
//  QuestionListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel = QuestionViewModel()
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
            VStack {
                TextField("Search questions...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top)

                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading questions...")
                    Spacer()
                }

                else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                }

                else if filteredQuestions.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No questions found.")
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    Spacer()
                }

                else {
                    List(filteredQuestions) { question in
                        NavigationLink(destination: QuestionDetailView(question: question)) {
                            Text(question.questionText)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Baby Questions")
        }
    }
}
