//
//  LullabyPlayerView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct LullabyPlayerView: View {
    let lullaby: Lullaby
    @ObservedObject var viewModel: LullabyViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    
    var isCurrentlyPlaying: Bool {
        viewModel.currentlyPlaying?.id == lullaby.id && viewModel.isPlaying
    }
    
    var progress: Double {
        guard viewModel.duration > 0 else { return 0 }
        return isDragging ? dragValue : (viewModel.currentTime / viewModel.duration)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3),
                    Color(red: 0.3, green: 0.2, blue: 0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("ŞUAN ÇALIYOR")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        Text("Ninni")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: lullaby)
                    }) {
                        Image(systemName: lullaby.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(lullaby.isFavorite ? .red : .white)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: lullaby.isFavorite)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(spacing: 32) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3),
                                        Color(red: 0.67, green: 0.32, blue: 0.89).opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 280, height: 280)
                            .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                        
                        Image(systemName: "music.note")
                            .font(.system(size: 80, weight: .light))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .scaleEffect(isCurrentlyPlaying ? 1.0 : 0.95)
                    .animation(.easeInOut(duration: 0.3), value: isCurrentlyPlaying)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text(lullaby.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("Geleneksel Ninni")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                if lullaby.audioFileName != nil {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Slider(
                                value: Binding(
                                    get: { progress },
                                    set: { newValue in
                                        dragValue = newValue
                                        if !isDragging {
                                            seekToTime(newValue)
                                        }
                                    }
                                ),
                                in: 0...1,
                                onEditingChanged: { editing in
                                    isDragging = editing
                                    if !editing {
                                        seekToTime(dragValue)
                                    }
                                }
                            )
                            .accentColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                            .padding(.horizontal, 4)
                            
                            HStack {
                                Text(formatTime(viewModel.currentTime))
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Spacer()
                                
                                Text(formatTime(viewModel.duration))
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        HStack(spacing: 40) {
                            Button(action: {
                                seekBackward()
                            }) {
                                Image(systemName: "gobackward.15")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                viewModel.playLullaby(lullaby)
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 80, height: 80)
                                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                                    
                                    Image(systemName: isCurrentlyPlaying ? "pause.fill" : "play.fill")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.3))
                                        .offset(x: isCurrentlyPlaying ? 0 : 2)
                                        .animation(.easeInOut(duration: 0.2), value: isCurrentlyPlaying)
                                }
                            }
                            .scaleEffect(isCurrentlyPlaying ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isCurrentlyPlaying)
                            
                            Button(action: {
                                seekForward()
                            }) {
                                Image(systemName: "goforward.15")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        HStack(spacing: 60) {
                            Button(action: {
                            }) {
                                Image(systemName: "shuffle")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Button(action: {
                                viewModel.stopAudio()
                            }) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Button(action: {
                            }) {
                                Image(systemName: "repeat")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "music.note.tv")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Bu ninni için ses dosyası bulunmuyor")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                }
                
                Spacer()
            }
        }
        .onAppear {
            if lullaby.audioFileName != nil && viewModel.currentlyPlaying?.id != lullaby.id {
                viewModel.playLullaby(lullaby)
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func seekToTime(_ progress: Double) {
        let newTime = progress * viewModel.duration
        viewModel.seekToTime(newTime)
    }
    
    private func seekForward() {
        viewModel.seekForward()
    }
    
    private func seekBackward() {
        viewModel.seekBackward()
    }
}
