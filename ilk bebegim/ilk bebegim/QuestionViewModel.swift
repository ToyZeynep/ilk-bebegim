//
//  QuestionViewModel.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import Foundation
import FirebaseFirestore

class QuestionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil

    private var db = Firestore.firestore()

    init() {
        fetchQuestions()
    }

    func fetchQuestions() {
        isLoading = true
        db.collection("questions").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Error fetching questions: \(error.localizedDescription)"
                self.isLoading = false
                return
            }

            guard let documents = snapshot?.documents else {
                self.errorMessage = "No documents found"
                self.isLoading = false
                return
            }

            self.questions = documents.compactMap { doc in
                try? doc.data(as: Question.self)
            }

            self.isLoading = false
        }
    }
}
