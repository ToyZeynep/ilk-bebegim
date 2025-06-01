//
//  MainTabView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = QuestionViewModel()
    @StateObject private var lullabyViewModel = LullabyViewModel()
    @StateObject private var whiteNoiseViewModel = WhiteNoiseViewModel()
    @StateObject private var growthViewModel = GrowthViewModel()

    var body: some View {
        TabView {
            QuestionListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Sorular")
                }
            
            SoundsView(lullabyViewModel: lullabyViewModel, whiteNoiseViewModel: whiteNoiseViewModel)
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Sesler")
                }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favoriler")
                }
            
            DailyTipView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Günlük İpucu")
                }
            
            BabyListView(viewModel: growthViewModel)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Büyüme")
                }
        }
        .accentColor(Color(red: 0.89, green: 0.47, blue: 0.76))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.89, green: 0.47, blue: 0.76, alpha: 1.0)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 0.89, green: 0.47, blue: 0.76, alpha: 1.0)]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
