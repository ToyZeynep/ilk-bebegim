//
//  WhiteNoiseCardView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct WhiteNoiseCardView: View {
    let noise: WhiteNoise
    @ObservedObject var viewModel: WhiteNoiseViewModel
    
    var isCurrentlyPlaying: Bool {
        viewModel.currentlyPlaying?.id == noise.id && viewModel.isPlaying
    }
    
    var body: some View {
        Button(action: {
            viewModel.playWhiteNoise(noise)
        }) {
            VStack(spacing: 16) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: noise.color).opacity(0.8),
                                    Color(hex: noise.color)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Color(hex: noise.color).opacity(0.3), radius: 8, y: 4)
                    
                    Image(systemName: noise.icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                    
                    // Playing indicator
                    if isCurrentlyPlaying {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 88, height: 88)
                            .animation(.easeInOut(duration: 0.3), value: isCurrentlyPlaying)
                    }
                }
                
                // Content
                VStack(spacing: 8) {
                    Text(noise.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(noise.description)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Play state indicator
                HStack(spacing: 4) {
                    if isCurrentlyPlaying {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: isCurrentlyPlaying)
                        
                        Text("Çalıyor")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(.green)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                        
                        Text("Durduruldu")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 220, maxHeight: 220)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isCurrentlyPlaying ?
                        Color(hex: noise.color).opacity(0.5) :
                        Color.clear,
                        lineWidth: 2
                    )
                    .animation(.easeInOut(duration: 0.3), value: isCurrentlyPlaying)
            )
            .scaleEffect(isCurrentlyPlaying ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isCurrentlyPlaying)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: {
                viewModel.toggleFavorite(for: noise)
            }) {
                Label(noise.isFavorite ? "Favorilerden Çıkar" : "Favorilere Ekle",
                      systemImage: noise.isFavorite ? "heart.slash" : "heart")
            }
        }
    }
}
