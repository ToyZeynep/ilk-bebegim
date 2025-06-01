//
//  DailyTipView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct DailyTipView: View {
    @StateObject private var viewModel = DailyTipViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient - diğer sayfalarla tutarlı
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.94, blue: 0.96),
                        Color(red: 0.95, green: 0.97, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    if let tip = viewModel.todaysTip {
                        // Ana içerik
                        VStack(spacing: 24) {
                            // Lightbulb icon
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 60))
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
                            
                            // İpucu kartı
                            VStack(spacing: 16) {
                                Text(tip.title)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
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
                                
                                Text(tip.message)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(6)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.08), radius: 16, y: 6)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.15),
                                                Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.15)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                        }
                        .padding(.horizontal, 24)
                        
                    } else {
                        Spacer()
                        VStack(spacing: 24) {
                            Image(systemName: "lightbulb.slash.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.4))
                            
                            Text("Bugün için henüz bir ipucu yok")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
        }
        .onAppear {
            viewModel.fetchTipForToday()
        }
    }
}
