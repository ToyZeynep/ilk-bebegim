//
//  SoundsView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct SoundsView: View {
    @ObservedObject var lullabyViewModel: LullabyViewModel
    @ObservedObject var whiteNoiseViewModel: WhiteNoiseViewModel
    
    @State private var selectedTab = 0
    @State private var lullabySearchText = ""
    @State private var whiteNoiseSearchText = ""
    @State private var showTimerSheet = false
    
    var filteredLullabies: [Lullaby] {
        if lullabySearchText.isEmpty {
            return lullabyViewModel.lullabies
        } else {
            return lullabyViewModel.lullabies.filter {
                $0.title.localizedCaseInsensitiveContains(lullabySearchText)
            }
        }
    }
    
    var filteredNoises: [WhiteNoise] {
        if whiteNoiseSearchText.isEmpty {
            return whiteNoiseViewModel.whiteNoises
        } else {
            return whiteNoiseViewModel.whiteNoises.filter {
                $0.title.localizedCaseInsensitiveContains(whiteNoiseSearchText) ||
                $0.description.localizedCaseInsensitiveContains(whiteNoiseSearchText)
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
                    // Segment Control
                    VStack(spacing: 16) {
                        Picker("Sesler", selection: $selectedTab) {
                            Text("Ninniler").tag(0)
                            Text("Beyaz Gürültü").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(height: 50)
                        .background(Color.clear)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        .onAppear {
                            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 0.89, green: 0.47, blue: 0.76, alpha: 1.0)
                            UISegmentedControl.appearance().setTitleTextAttributes([
                                .foregroundColor: UIColor.white,
                                .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
                            ], for: .selected)
                            UISegmentedControl.appearance().setTitleTextAttributes([
                                .foregroundColor: UIColor.darkGray,
                                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
                            ], for: .normal)
                            UISegmentedControl.appearance().backgroundColor = UIColor.white
                        }
                        
                        // Search bar
//                        HStack {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(.gray)
//                                .font(.system(size: 16, weight: .medium))
//
//                            if selectedTab == 0 {
//                                TextField("Ninnilerde ara...", text: $lullabySearchText)
//                                    .font(.system(size: 16, weight: .medium, design: .rounded))
//                            } else {
//                                TextField("Seslerde ara...", text: $whiteNoiseSearchText)
//                                    .font(.system(size: 16, weight: .medium, design: .rounded))
//                            }
//                        }
//                        .padding(16)
//                        .background(
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(Color.white)
//                                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
//                        )
                        
                        // White noise player controls (eğer çalıyorsa)
                        if selectedTab == 1 && whiteNoiseViewModel.currentlyPlaying != nil {
                            PlayerControlsView(viewModel: whiteNoiseViewModel, showTimerSheet: $showTimerSheet)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        // Ninniler Tab
                        LullabiesContentView(
                            lullabies: filteredLullabies,
                            viewModel: lullabyViewModel
                        )
                        .tag(0)
                        
                        // Beyaz Gürültü Tab
                        WhiteNoiseContentView(
                            noises: filteredNoises,
                            viewModel: whiteNoiseViewModel
                        )
                        .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: selectedTab)
                }
            }
        }
        .sheet(isPresented: $showTimerSheet) {
            TimerPickerView(viewModel: whiteNoiseViewModel)
        }
    }
}

// MARK: - Lullabies Content View

struct LullabiesContentView: View {
    let lullabies: [Lullaby]
    @ObservedObject var viewModel: LullabyViewModel
    
    var body: some View {
        if viewModel.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(Color(red: 0.89, green: 0.47, blue: 0.76))
                Text("Ninniler yükleniyor...")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        } else if let error = viewModel.errorMessage {
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
        } else if lullabies.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 64))
                    .foregroundColor(.gray.opacity(0.4))
                Text("Ninni bulunamadı")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
            }
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(lullabies) { lullaby in
                        if lullaby.audioFileName != nil {
                            // Sesli ninni -> Player
                            NavigationLink(destination: LullabyPlayerView(lullaby: lullaby, viewModel: viewModel)) {
                                LullabyCardView(lullaby: lullaby, viewModel: viewModel)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            // Sadece sözlü -> Detay
                            NavigationLink(destination: LullabyDetailView(lullaby: lullaby, viewModel: viewModel)) {
                                LullabyCardView(lullaby: lullaby, viewModel: viewModel)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - White Noise Content View

struct WhiteNoiseContentView: View {
    let noises: [WhiteNoise]
    @ObservedObject var viewModel: WhiteNoiseViewModel
    
    var body: some View {
        if viewModel.isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(Color(red: 0.89, green: 0.47, blue: 0.76))
                Text("Sesler yükleniyor...")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        } else if let error = viewModel.errorMessage {
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
        } else if noises.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "waveform.slash")
                    .font(.system(size: 64))
                    .foregroundColor(.gray.opacity(0.4))
                Text("Ses bulunamadı")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
            }
        } else {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 16) {
                    ForEach(noises) { noise in
                        WhiteNoiseCardView(noise: noise, viewModel: viewModel)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }
}
