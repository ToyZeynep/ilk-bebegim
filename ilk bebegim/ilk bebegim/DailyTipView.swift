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
        VStack(alignment: .leading, spacing: 16) {
            if let tip = viewModel.todaysTip {
                Text("Today's Tip")
                    .font(.title)
                    .bold()

                Text(tip.title)
                    .font(.headline)
                    .foregroundColor(.blue)

                Text(tip.message)
                    .font(.body)
            } else {
                Text("No tip for today yet.")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Daily Tip 💡")
        .onAppear {
            viewModel.fetchTipForToday()
        }
    }
}
