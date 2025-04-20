//
//  Question.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation
import FirebaseFirestore

struct Question: Identifiable, Codable {
    @DocumentID var id: String?
    var questionText: String
    var answers: [String]
    var isFavorite: Bool? = false
}
