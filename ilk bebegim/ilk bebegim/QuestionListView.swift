//
//  QuestionListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import SwiftUI

struct QuestionListView: View {
    @State private var searchText: String = ""
    @State private var isLoading: Bool = false
    
    // Use mock data for now
    var questions: [Question] = sampleQuestions
    
    var filteredQuestions: [Question] {
        if searchText.isEmpty {
            return questions
        } else {
            return questions.filter {
                $0.questionText.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search questions...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Loading Indicator
                if isLoading {
                    Spacer()
                    ProgressView("Loading questions...")
                    Spacer()
                }
                // Empty State
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
                // List View
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

let sampleQuestions = [
    Question(questionText: "Why do babies cry?", answers: [
        "They might be hungry",
        "Their diaper is dirty",
        "They want to be held"
    ]),
    Question(questionText: "When do babies start crawling?", answers: [
        "Usually between 6 to 10 months",
        "It varies from baby to baby"
    ])
]
