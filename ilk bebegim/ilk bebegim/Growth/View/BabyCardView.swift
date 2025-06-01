//
//  BabyCardView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct BabyCardView: View {
    let profile: BabyProfile
    @ObservedObject var viewModel: GrowthViewModel
    
    var latestRecord: GrowthRecord? {
        viewModel.getLatestRecord(for: profile)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: profile.gender.color).opacity(0.8),
                                Color(hex: profile.gender.color)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: Color(hex: profile.gender.color).opacity(0.3), radius: 6, y: 3)
                
                Image(systemName: profile.gender.icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(profile.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(profile.gender.rawValue)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(hex: profile.gender.color))
                        )
                }
                
                Text(profile.ageText)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(.darkGray))
                
                if let latest = latestRecord {
                    HStack(spacing: 8) {
                        if let weight = latest.weight {
                            MeasurementBadgeView(
                                value: String(format: "%.1f kg", weight),
                                color: "#FF6B6B"
                            )
                        }
                        
                        if let height = latest.height {
                            MeasurementBadgeView(
                                value: String(format: "%.0f cm", height),
                                color: "#4A90E2"
                            )
                        }
                        
                        Spacer()
                        
                        Text(latest.formattedDate)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("Henüz ölçüm eklenmemiş")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            
            // Arrow indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(hex: profile.gender.color).opacity(0.2),
                            Color(hex: profile.gender.color).opacity(0.1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
        )
        .contextMenu {
            Button(action: {
                viewModel.deleteBabyProfile(profile)
            }) {
                Label("Sil", systemImage: "trash")
            }
            .foregroundColor(.red)
        }
    }
}
