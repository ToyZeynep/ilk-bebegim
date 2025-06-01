//
//  GrowthDetailView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct GrowthDetailView: View {
    let babyProfile: BabyProfile
    @ObservedObject var viewModel: GrowthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var body: some View {
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
                // Baby header
                BabyDetailHeaderView(profile: babyProfile, viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                let babyRecords = viewModel.getGrowthRecords(for: babyProfile)
                
                if babyRecords.isEmpty {
                    Spacer()
                    EmptyGrowthStateView(viewModel: viewModel)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            GrowthStatsView(babyProfile: babyProfile, viewModel: viewModel)
                            RecentRecordsView(babyProfile: babyProfile, viewModel: viewModel)
                            QuickActionsView( viewModel: viewModel, shareAction: {
                                shareGrowthReport(for: babyProfile)
                            })
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddRecord) {
            AddGrowthRecordView(babyProfile: babyProfile, viewModel: viewModel)
        }
        .alert("Profili Sil", isPresented: $showingDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                viewModel.deleteBabyProfile(babyProfile)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("\(babyProfile.name) profilini ve tüm ölçüm kayıtlarını silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
        }
    }
    
    private func shareGrowthReport(for baby: BabyProfile) {
        let babyRecords = viewModel.getGrowthRecords(for: baby)
        
        var reportText = "📊 \(baby.name) - Büyüme Raporu\n"
        reportText += "👶 Yaş: \(baby.ageText)\n"
        reportText += "👤 Cinsiyet: \(baby.gender.rawValue)\n\n"
        
        if let latest = viewModel.getLatestRecord(for: baby) {
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
        
        if babyRecords.count > 1 {
            reportText += "📋 Geçmiş Kayıtlar:\n"
            for record in babyRecords.suffix(5).reversed() {
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
