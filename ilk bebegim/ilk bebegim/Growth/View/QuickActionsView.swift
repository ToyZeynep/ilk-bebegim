//
//  QuickActionsView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct QuickActionsView: View {
    @ObservedObject var viewModel: GrowthViewModel
    let shareAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Hızlı İşlemler")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "Ölçüm Ekle",
                    icon: "plus.circle.fill",
                    color: "#89E5AB",
                    action: {
                        viewModel.showingAddRecord = true
                    }
                )
                
                QuickActionButton(
                    title: "Rapor Paylaş",
                    icon: "square.and.arrow.up",
                    color: "#4A90E2",
                    action: shareAction
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: color))
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
