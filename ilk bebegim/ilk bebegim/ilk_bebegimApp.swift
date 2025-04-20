//
//  ilk_bebegimApp.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI
import Firebase

@main
struct IlkBebegimApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            QuestionListView()
        }
    }
}
