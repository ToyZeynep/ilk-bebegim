//
//  DailyTip.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import Foundation
import FirebaseFirestore

struct DailyTip: Identifiable, Codable {
    @DocumentID var id: String?
    var day: Int
    var title: String
    var message: String
}
