//
//  BabyListContentView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct BabyListContentView: View {
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    Text("Bebeklerim")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.89, green: 0.47, blue: 0.76),
                                    Color(red: 0.67, green: 0.32, blue: 0.89)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.babyProfiles) { profile in
                        NavigationLink(destination: GrowthDetailView(babyProfile: profile, viewModel: viewModel)) {
                            BabyCardView(profile: profile, viewModel: viewModel)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    AddBabyCardView(viewModel: viewModel)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }
}
