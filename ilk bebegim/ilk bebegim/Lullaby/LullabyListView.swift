//
//  LullabyListView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct LullabyListView: View {
    @ObservedObject var viewModel: LullabyViewModel
    @State private var searchText: String = ""
    
    var filteredLullabies: [Lullaby] {
        if searchText.isEmpty {
            return viewModel.lullabies
        } else {
            return viewModel.lullabies.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
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
                    // Search bar
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField("Ninnilerde ara...", text: $searchText)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                        )
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
                            Text("Ninniler yükleniyor...")
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
                    } else if filteredLullabies.isEmpty {
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 64))
                                .foregroundColor(.gray.opacity(0.4))
                            Text("Ninni bulunamadı")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredLullabies) { lullaby in
                                    if lullaby.audioFileName != nil {
                                        // Sesli ninni -> Direkt player aç
                                        NavigationLink(destination: LullabyPlayerView(lullaby: lullaby, viewModel: viewModel)) {
                                            LullabyCardView(
                                                lullaby: lullaby,
                                                viewModel: viewModel
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    } else {
                                        // Sadece sözlü -> Detay sayfası
                                        NavigationLink(destination: LullabyDetailView(lullaby: lullaby, viewModel: viewModel)) {
                                            LullabyCardView(
                                                lullaby: lullaby,
                                                viewModel: viewModel
                                            )
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
        }
        .toolbar(.visible, for: .tabBar)
    }
}
