//
//  GrowthView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct GrowthView: View {
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
                
                if viewModel.babyProfile == nil {
                    // Profil kurulumu
                    BabyProfileSetupView(viewModel: viewModel)
                } else {
                    // Ana büyüme takibi
                    GrowthMainView(viewModel: viewModel)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddRecord) {
            if let profile = viewModel.babyProfile {
                AddGrowthRecordView(babyProfile: profile, viewModel: viewModel)
            }
        }
        .sheet(isPresented: $viewModel.showingProfileSetup) {
            BabyProfileSetupView(viewModel: viewModel)
        }
    }
}
