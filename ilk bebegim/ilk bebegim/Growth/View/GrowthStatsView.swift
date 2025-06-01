//
//  GrowthStatsView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct GrowthStatsView: View {
    let babyProfile: BabyProfile
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Son Ölçümler")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                Spacer()
            }
            
            if let latest = viewModel.getLatestRecord(for: babyProfile) {
                HStack(spacing: 12) {
                    // Weight
                    if let weight = latest.weight {
                        StatCardView(
                            title: "Kilo",
                            value: viewModel.formatWeight(weight),
                            change: viewModel.recentWeightGain(for: babyProfile).map {
                                $0 >= 0 ? "+\(viewModel.formatWeight($0))" : viewModel.formatWeight($0)
                            },
                            icon: "scalemass.fill",
                            color: "#FF6B6B"
                        )
                    }
                    
                    // Height
                    if let height = latest.height {
                        StatCardView(
                            title: "Boy",
                            value: viewModel.formatHeight(height),
                            change: viewModel.recentHeightGain(for: babyProfile).map {
                                $0 >= 0 ? "+\(String(format: "%.0f cm", $0))" : String(format: "%.0f cm", $0)
                            },
                            icon: "ruler.fill",
                            color: "#4A90E2"
                        )
                    }
                    
                    // Head circumference
                    if let headCirc = latest.headCircumference {
                        StatCardView(
                            title: "Baş Çevresi",
                            value: viewModel.formatHeadCircumference(headCirc),
                            change: nil,
                            icon: "circle.dotted",
                            color: "#87CEEB"
                        )
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("Henüz ölçüm kaydı yok")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    
                    Text("İlk ölçümünüzü ekleyerek başlayın")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.gray.opacity(0.8))
                }
                .padding(.vertical, 20)
            }
        }
    }
}
