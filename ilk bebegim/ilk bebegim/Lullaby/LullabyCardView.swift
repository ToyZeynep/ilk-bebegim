//
//  LullabyCardView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct LullabyCardView: View {
    let lullaby: Lullaby
    @ObservedObject var viewModel: LullabyViewModel
    
    var isCurrentlyPlaying: Bool {
        viewModel.currentlyPlaying?.id == lullaby.id && viewModel.isPlaying
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Play button
            Button(action: {
                viewModel.playLullaby(lullaby)
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.89, green: 0.47, blue: 0.76),
                                    Color(red: 0.67, green: 0.32, blue: 0.89)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3), radius: 4, y: 2)
                    
                    Image(systemName: lullaby.audioFileName == nil ? "music.note.tv" :
                          isCurrentlyPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.2), value: isCurrentlyPlaying)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(lullaby.audioFileName == nil)
            .opacity(lullaby.audioFileName == nil ? 0.5 : 1.0)
            
            // Lullaby content
            VStack(alignment: .leading, spacing: 8) {
                Text(lullaby.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                HStack {
                    if let duration = lullaby.duration {
                        Text(formatDuration(duration))
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                if lullaby.audioFileName == nil {
                    Text("Sadece sözler")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.orange)
                        .italic()
                }
            }
            
            Spacer()
            
            // Favorite button
            Button(action: {
                viewModel.toggleFavorite(for: lullaby)
            }) {
                Image(systemName: lullaby.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(lullaby.isFavorite ? .red : .gray)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: lullaby.isFavorite)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 12, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isCurrentlyPlaying ?
                    LinearGradient(
                        colors: [
                            Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.5),
                            Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.5)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [
                            Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.1),
                            Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: isCurrentlyPlaying ? 2 : 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isCurrentlyPlaying)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
