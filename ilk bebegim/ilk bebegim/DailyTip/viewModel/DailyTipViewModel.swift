//
//  DailyTipViewModel.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import Foundation
import FirebaseFirestore

class DailyTipViewModel: ObservableObject {
    @Published var todaysTip: DailyTip?

    private var db = Firestore.firestore()

    func fetchTipForToday() {
        let today = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0

        db.collection("dailyTips")
            .whereField("day", isEqualTo: today)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tip: \(error.localizedDescription)")
                    return
                }

                if let documents = snapshot?.documents,
                   let doc = documents.first,
                   let tip = try? doc.data(as: DailyTip.self) {
                    DispatchQueue.main.async {
                        self.todaysTip = tip
                    }
                } else {
                    print("No tip found for today.")
                }
            }
    }
}
