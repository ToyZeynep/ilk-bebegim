//
//  WhiteNoiseListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct WhiteNoiseListView: View {
    @ObservedObject var viewModel: WhiteNoiseViewModel
    @State private var searchText: String = ""
    @State private var showTimerSheet = false
    
    var filteredNoises: [WhiteNoise] {
        if searchText.isEmpty {
            return viewModel.whiteNoises
        } else {
            return viewModel.whiteNoises.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.94, blue: 0.96),
                        Color(red: 0.95, green: 0.97, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar ve controls
                    VStack(spacing: 16) {
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(.gray)
//                                .font(.system(size: 16, weight: .medium))
//                            
//                            TextField("Seslerde ara...", text: $searchText)
//                                .font(.system(size: 16, weight: .medium, design: .rounded))
//                        }
//                        .padding(16)
//                        .background(
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(Color.white)
//                                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
//                        )
                        
                        // Player controls (eğer çalıyorsa)
                        if viewModel.currentlyPlaying != nil {
                            PlayerControlsView(viewModel: viewModel, showTimerSheet: $showTimerSheet)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Content
                    if viewModel.isLoading {
                        Spacer()
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(Color(red: 0.89, green: 0.47, blue: 0.76))
                            Text("Sesler yükleniyor...")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        Spacer()
                    } else if filteredNoises.isEmpty {
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "waveform.slash")
                                .font(.system(size: 64))
                                .foregroundColor(.gray.opacity(0.4))
                            Text("Ses bulunamadı")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ], spacing: 16) {
                                ForEach(filteredNoises) { noise in
                                    WhiteNoiseCardView(noise: noise, viewModel: viewModel)
                                        .frame(maxWidth: .infinity) // Eşit genişlik için
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showTimerSheet) {
            TimerPickerView(viewModel: viewModel)
        }
    }
}

// MARK: - Player Controls View

struct PlayerControlsView: View {
    @ObservedObject var viewModel: WhiteNoiseViewModel
    @Binding var showTimerSheet: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Currently playing info
            HStack {
                if let current = viewModel.currentlyPlaying {
                    HStack(spacing: 12) {
                        Image(systemName: current.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: current.color))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(current.title)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            if viewModel.remainingTime > 0 {
                                Text("Kalan: \(viewModel.formatTime(viewModel.remainingTime))")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Play/Pause button
                        Button(action: {
                            if viewModel.isPlaying {
                                viewModel.pauseAudio()
                            } else {
                                viewModel.resumeAudio()
                            }
                        }) {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color(red: 0.89, green: 0.47, blue: 0.76))
                                )
                        }
                        
                        // Stop button
                        Button(action: {
                            viewModel.stopAudio()
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color.gray)
                                )
                        }
                        
                        // Timer button
                        Button(action: {
                            showTimerSheet = true
                        }) {
                            Image(systemName: "timer")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                )
                        }
                    }
                }
            }
            
            // Volume slider
            VStack(spacing: 6) {
                HStack {
                    Image(systemName: "speaker.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Slider(value: Binding(
                        get: { viewModel.volume },
                        set: { viewModel.setVolume($0) }
                    ), in: 0...1)
                    .accentColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Text("Ses: \(Int(viewModel.volume * 100))%")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}

// MARK: - Timer Picker View

struct TimerPickerView: View {
    @ObservedObject var viewModel: WhiteNoiseViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMinutes = 0
    
    let timerOptions = [0, 15, 30, 45, 60, 90, 120] // dakika
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Otomatik Durdurma")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                VStack(spacing: 16) {
                    ForEach(timerOptions, id: \.self) { minutes in
                        Button(action: {
                            selectedMinutes = minutes
                            viewModel.setTimer(minutes: minutes)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(minutes == 0 ? "Süresiz" : "\(minutes) dakika")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if viewModel.timerMinutes == minutes {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.timerMinutes == minutes ?
                                          Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.1) :
                                          Color.clear)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RRGGBB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // AARRGGBB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
