//
//  AddBabyCardView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct AddBabyCardView: View {
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        Button(action: {
            viewModel.showingProfileSetup = true
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.8),
                                    Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3), radius: 6, y: 3)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text("Yeni Bebek Ekle")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text("Başka bir bebeğin takibini başlat")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.darkGray))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
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
                                Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3),
                                Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.3)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
