//
//  LullabyDetailView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct LullabyDetailView: View {
    let lullaby: Lullaby
    @ObservedObject var viewModel: LullabyViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showFullScreenPlayer = false
    
    var isCurrentlyPlaying: Bool {
        viewModel.currentlyPlaying?.id == lullaby.id && viewModel.isPlaying
    }
    
    var progress: Double {
        guard viewModel.duration > 0 else { return 0 }
        return viewModel.currentTime / viewModel.duration
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.94, blue: 0.96),
                    Color(red: 0.95, green: 0.97, blue: 0.99)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    if lullaby.audioFileName != nil {
                        VStack(spacing: 20) {
                            Button(action: {
                                if lullaby.audioFileName != nil {
                                    showFullScreenPlayer = true
                                } else {
                                    viewModel.playLullaby(lullaby)
                                }
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
                                        .frame(width: 80, height: 80)
                                        .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.4), radius: 12, y: 6)
                                    
                                    Image(systemName: isCurrentlyPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .animation(.easeInOut(duration: 0.2), value: isCurrentlyPlaying)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if viewModel.currentlyPlaying?.id == lullaby.id {
                                VStack(spacing: 8) {
                                    ProgressView(value: progress)
                                        .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 0.89, green: 0.47, blue: 0.76)))
                                        .scaleEffect(y: 2)
                                    
                                    HStack {
                                        Text(formatTime(viewModel.currentTime))
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Text(formatTime(viewModel.duration))
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            HStack(spacing: 32) {
                                Button(action: {
                                    viewModel.stopAudio()
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    viewModel.toggleFavorite(for: lullaby)
                                }) {
                                    Image(systemName: lullaby.isFavorite ? "heart.fill" : "heart")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(lullaby.isFavorite ? .red : .gray)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: lullaby.isFavorite)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 16, y: 6)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ninni Sözleri")
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
                        
                        Text(lullaby.lyrics)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                            .lineSpacing(8)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                    )
                    
                    if lullaby.duration != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bilgiler")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                if let duration = lullaby.duration {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                                        Text("Süre: \(formatTime(duration))")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                                    }
                                }
                                
                                if lullaby.audioFileName == nil {
                                    HStack {
                                        Image(systemName: "music.note.tv")
                                            .foregroundColor(.orange)
                                        Text("Sadece sözler mevcut")
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.7))
                                .shadow(color: .black.opacity(0.03), radius: 4, y: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(lullaby.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
