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
        VStack(spacing: 0) {
            HStack {
                Text("Bugünün İpucu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .padding(.top, 16)
            }
            .padding()

            if let tip = viewModel.todaysTip {
                
                Text(tip.title)
                    .font(.headline)
                    .foregroundColor(.blue)

                Text(tip.message)
                    .font(.body)
            } else {
                Text("Bugün için henüz bir ipucu yok.")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Günlük İpucu 💡")
        .onAppear {
            viewModel.fetchTipForToday()
        }
    }
}
