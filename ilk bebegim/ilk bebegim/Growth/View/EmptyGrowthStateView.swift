//
//  EmptyGrowthStateView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct EmptyGrowthStateView: View {
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 72))
                .foregroundColor(.gray.opacity(0.4))
            
            VStack(spacing: 12) {
                Text("Büyüme Takibine Başla")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                Text("Bebeğinizin boy ve kilo gelişimini takip etmek için ilk ölçümü ekleyin")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(.darkGray))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.showingAddRecord = true
                }) {
                    Text("İlk Ölçüm Ekle")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
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
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 32)
    }
}
