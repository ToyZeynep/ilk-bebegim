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
          VStack(spacing: 0) {
              HStack {
                  Text("Sorular")
                      .font(.largeTitle)
                      .fontWeight(.bold)
                      .foregroundColor(.accentColor)
                      .padding(.top, 16)
              }
              .padding()
              
              VStack(spacing: 12) {
                  TextField("Sorularda ara...", text: $searchText)
                      .padding(10)
                      .background(Color(.systemGray6))
                      .cornerRadius(10)
                      .padding(.horizontal)
                  
                  if viewModel.isLoading {
                      Spacer()
                      ProgressView("Sorular yükleniyor...")
                      Spacer()
                  } else if let error = viewModel.errorMessage {
                      Spacer()
                      Text(error)
                          .foregroundColor(.red)
                          .padding()
                      Spacer()
                  } else if filteredQuestions.isEmpty {
                      Spacer()
                      VStack {
                          Image(systemName: "questionmark.circle")
                              .font(.system(size: 50))
                              .foregroundColor(.gray)
                          Text("Soru bulunamadı.")
                              .foregroundColor(.gray)
                              .padding(.top, 4)
                      }
                      Spacer()
                  } else {
                      ScrollView {
                          LazyVStack(spacing: 16) {
                              ForEach(filteredQuestions) { question in
                                  NavigationLink(destination: QuestionDetailView(question: question)) {
                                      QuestionCardView(question: question, viewModel: viewModel)
                                  }
                                  .buttonStyle(PlainButtonStyle())
                              }
                          }
                          .padding(.horizontal)
                          .padding(.top)
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
