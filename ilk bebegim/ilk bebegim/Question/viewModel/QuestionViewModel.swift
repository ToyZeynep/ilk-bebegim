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
    private let favoritesKey = "favoriteQuestionIDs"

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

            self.loadFavoritesFromUserDefaults()

            self.isLoading = false
        }
    }

    private func loadFavoritesFromUserDefaults() {
        guard let savedIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else { return }

        for id in savedIDs {
            if let index = questions.firstIndex(where: { $0.id == id }) {
                questions[index].isFavorite = true
            }
        }
    }
    
    func toggleFavorite(for question: Question) {
        guard let id = question.id else { return }

        if let index = questions.firstIndex(where: { $0.id == id }) {
            var updated = questions[index]
            updated.isFavorite = !(updated.isFavorite ?? false)
            questions[index] = updated
            saveFavoritesToUserDefaults()
        }
    }
    
    private func saveFavoritesToUserDefaults() {
        let ids = questions.compactMap { $0.id }.filter { id in
            questions.first(where: { $0.id == id })?.isFavorite == true
        }
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }
}
