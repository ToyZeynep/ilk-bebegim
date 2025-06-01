//
//  BabyListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct BabyListView: View {
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.94, blue: 0.96),
                        Color(red: 0.95, green: 0.97, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if viewModel.babyProfiles.isEmpty {
                    EmptyBabyListView(viewModel: viewModel)
                } else {
                    BabyListContentView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingProfileSetup) {
            BabyProfileSetupView(viewModel: viewModel)
        }
    }
}
