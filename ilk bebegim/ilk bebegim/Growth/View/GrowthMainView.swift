//
//  GrowthMainView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct GrowthMainView: View {
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            if let profile = viewModel.babyProfile {
                BabyInfoHeaderView(profile: profile, viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            
            if viewModel.growthRecords.isEmpty {
                Spacer()
                EmptyGrowthStateView(viewModel: viewModel)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if let profile = viewModel.babyProfile {
                            GrowthStatsView(babyProfile: profile, viewModel: viewModel)
                            
                            RecentRecordsView(babyProfile: profile, viewModel: viewModel)
                            
                            QuickActionsView(viewModel: viewModel, shareAction: shareGrowthReport)
                        }
                    }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showingAddRecord = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                }
            }
        }
    }
    
    private func shareGrowthReport() {
        guard let profile = viewModel.babyProfile else { return }
        
        var reportText = "📊 \(profile.name) - Büyüme Raporu\n"
        reportText += "👶 Yaş: \(profile.ageText)\n"
        reportText += "👤 Cinsiyet: \(profile.gender.rawValue)\n\n"
        
        if let latest = viewModel.latestRecord {
            reportText += "📈 Son Ölçümler (\(latest.formattedDate)):\n"
            if let weight = latest.weight {
                reportText += "⚖️ Kilo: \(viewModel.formatWeight(weight))\n"
            }
            if let height = latest.height {
                reportText += "📏 Boy: \(viewModel.formatHeight(height))\n"
            }
            if let headCirc = latest.headCircumference {
                reportText += "⭕ Baş Çevresi: \(viewModel.formatHeadCircumference(headCirc))\n"
            }
            reportText += "\n"
        }
        
        if viewModel.growthRecords.count > 1 {
            reportText += "📋 Geçmiş Kayıtlar:\n"
            for record in viewModel.growthRecords.suffix(5).reversed() {
                reportText += "\n📅 \(record.formattedDate) - \(record.ageText)\n"
                if let weight = record.weight {
                    reportText += "• Kilo: \(viewModel.formatWeight(weight))\n"
                }
                if let height = record.height {
                    reportText += "• Boy: \(viewModel.formatHeight(height))\n"
                }
                if let headCirc = record.headCircumference {
                    reportText += "• Baş Çevresi: \(viewModel.formatHeadCircumference(headCirc))\n"
                }
                if let notes = record.notes, !notes.isEmpty {
                    reportText += "📝 Not: \(notes)\n"
                }
            }
        }
        
        reportText += "\n📱 İlk Bebeğim uygulamasından oluşturuldu"
        
        let activityController = UIActivityViewController(
            activityItems: [reportText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
}
