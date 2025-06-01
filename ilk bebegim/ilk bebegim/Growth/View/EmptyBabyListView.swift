//
//  EmptyBabyListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct EmptyBabyListView: View {
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "figure.child.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.89, green: 0.47, blue: 0.76),
                                Color(red: 0.67, green: 0.32, blue: 0.89)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3), radius: 8, y: 4)
                
                VStack(spacing: 12) {
                    Text("Büyüme Takibine Başla")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
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
                        .multilineTextAlignment(.center)
                    
                    Text("Bebeğinizin boy ve kilo gelişimini takip edin. İlk bebek profilini oluşturun.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.darkGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            
            Button(action: {
                viewModel.showingProfileSetup = true
            }) {
                Text("İlk Bebeği Ekle")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.89, green: 0.47, blue: 0.76),
                                        Color(red: 0.67, green: 0.32, blue: 0.89)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.4), radius: 12, y: 6)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 40)
        }
        .padding(.horizontal, 32)
    }
}
