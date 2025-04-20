//
//  MainTabView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = QuestionViewModel()

    var body: some View {
        TabView {
            QuestionListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("Questions")
                }

            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }

            DailyTipView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Daily Tip")
                }
        }
    }
}
