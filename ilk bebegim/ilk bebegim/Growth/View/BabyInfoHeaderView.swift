//
//  BabyInfoHeaderView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct BabyInfoHeaderView: View {
    let profile: BabyProfile
    @ObservedObject var viewModel: GrowthViewModel
    
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
                    .frame(width: 80, height: 80)
                    .shadow(color: Color(hex: profile.gender.color).opacity(0.3), radius: 8, y: 4)
                
                Image(systemName: profile.gender.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(profile.name)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                Text(profile.ageText)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(.darkGray))
                
                Text(profile.gender.rawValue)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: profile.gender.color))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(hex: profile.gender.color).opacity(0.1))
                    )
            }
            
            Spacer()
            
            Button(action: {
                viewModel.showingProfileSetup = true
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
        )
    }
}
