//
//  GrowthViewModel.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation
import SwiftUI

class GrowthViewModel: ObservableObject {
    @Published var babyProfiles: [BabyProfile] = []
    @Published var growthRecords: [GrowthRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Form states
    @Published var showingAddRecord = false
    @Published var showingProfileSetup = false
    @Published var currentBabyId: UUID? = nil // Hangi bebek için işlem yapılıyor
    
    private let userDefaults = UserDefaults.standard
    private let profilesKey = "BabyProfiles"
    private let recordsKey = "GrowthRecords"
    
    // Backward compatibility - tek bebek sistemi için
    var babyProfile: BabyProfile? {
        babyProfiles.first
    }
    
    init() {
        loadBabyProfiles()
        loadGrowthRecords()
    }
    
    // MARK: - Baby Profile Management
    
    func saveBabyProfile(_ profile: BabyProfile) {
        if let index = babyProfiles.firstIndex(where: { $0.id == profile.id }) {
            babyProfiles[index] = profile
        } else {
            babyProfiles.append(profile)
        }
        saveBabyProfiles()
    }
    
    func editBabyProfile(_ profile: BabyProfile) {
        currentBabyId = profile.id
        showingProfileSetup = true
    }
    
    func deleteBabyProfile(_ profile: BabyProfile) {
        babyProfiles.removeAll { $0.id == profile.id }
        growthRecords.removeAll { $0.babyId == profile.id }
        saveBabyProfiles()
        saveGrowthRecords()
    }
    
    private func saveBabyProfiles() {
        if let encoded = try? JSONEncoder().encode(babyProfiles) {
            userDefaults.set(encoded, forKey: profilesKey)
        }
    }
    
    private func loadBabyProfiles() {
        if let data = userDefaults.data(forKey: profilesKey),
           let profiles = try? JSONDecoder().decode([BabyProfile].self, from: data) {
            babyProfiles = profiles
        }
    }
    
    // MARK: - Growth Records Management
    
    func addGrowthRecord(_ record: GrowthRecord) {
        growthRecords.append(record)
        growthRecords.sort { $0.date < $1.date }
        saveGrowthRecords()
    }
    
    func deleteGrowthRecord(_ record: GrowthRecord) {
        growthRecords.removeAll { $0.id == record.id }
        saveGrowthRecords()
    }
    
    func showAddRecord(for baby: BabyProfile) {
        currentBabyId = baby.id
        showingAddRecord = true
    }
    
    private func saveGrowthRecords() {
        if let encoded = try? JSONEncoder().encode(growthRecords) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
    }
    
    private func loadGrowthRecords() {
        if let data = userDefaults.data(forKey: recordsKey),
           let records = try? JSONDecoder().decode([GrowthRecord].self, from: data) {
            
            // Migration: Eski kayıtları ilk bebeğe ata
            var migratedRecords = records
            for i in 0..<migratedRecords.count {
                // Eğer babyId boşsa (eski kayıt), ilk bebeğe ata
                if migratedRecords[i].babyId.uuidString == "00000000-0000-0000-0000-000000000000" {
                    if let firstBaby = babyProfiles.first {
                        migratedRecords[i] = GrowthRecord(
                            babyId: firstBaby.id,
                            date: migratedRecords[i].date,
                            ageInDays: migratedRecords[i].ageInDays,
                            weight: migratedRecords[i].weight,
                            height: migratedRecords[i].height,
                            headCircumference: migratedRecords[i].headCircumference,
                            notes: migratedRecords[i].notes,
                            photoData: migratedRecords[i].photoData
                        )
                    }
                }
            }
            
            growthRecords = migratedRecords.sorted { $0.date < $1.date }
            
            // Migration sonrası kaydet
            saveGrowthRecords()
        }
    }
    
    // MARK: - Data Queries for specific baby
    
    func getGrowthRecords(for baby: BabyProfile) -> [GrowthRecord] {
        let filtered = growthRecords.filter { $0.babyId == baby.id }
        print("👶 \(baby.name) için kayıtlar: \(filtered.count) adet")
        print("👶 Baby ID: \(baby.id)")
        print("📊 Tüm kayıtlar: \(growthRecords.count) adet")
        for record in growthRecords {
            print("📝 Kayıt - Baby ID: \(record.babyId), Tarih: \(record.formattedDate)")
        }
        return filtered.sorted { $0.date < $1.date }
    }
    
    func getLatestRecord(for baby: BabyProfile) -> GrowthRecord? {
        return getGrowthRecords(for: baby).last
    }
    
    func getWeightRecords(for baby: BabyProfile) -> [GrowthRecord] {
        return getGrowthRecords(for: baby).filter { $0.weight != nil }
    }
    
    func getHeightRecords(for baby: BabyProfile) -> [GrowthRecord] {
        return getGrowthRecords(for: baby).filter { $0.height != nil }
    }
    
    func getHeadCircumferenceRecords(for baby: BabyProfile) -> [GrowthRecord] {
        return getGrowthRecords(for: baby).filter { $0.headCircumference != nil }
    }
    
    // Son 30 gündeki artış
    func recentWeightGain(for baby: BabyProfile) -> Double? {
        let recentRecords = getWeightRecords(for: baby).suffix(2)
        guard recentRecords.count >= 2 else { return nil }
        
        let latest = recentRecords.last!
        let previous = recentRecords.dropLast().last!
        
        return latest.weight! - previous.weight!
    }
    
    func recentHeightGain(for baby: BabyProfile) -> Double? {
        let recentRecords = getHeightRecords(for: baby).suffix(2)
        guard recentRecords.count >= 2 else { return nil }
        
        let latest = recentRecords.last!
        let previous = recentRecords.dropLast().last!
        
        return latest.height! - previous.height!
    }
    
    // MARK: - Backward Compatibility (for old GrowthView)
    
    var latestRecord: GrowthRecord? {
        guard let baby = babyProfile else { return nil }
        return getLatestRecord(for: baby)
    }
    
    var weightRecords: [GrowthRecord] {
        guard let baby = babyProfile else { return [] }
        return getWeightRecords(for: baby)
    }
    
    var heightRecords: [GrowthRecord] {
        guard let baby = babyProfile else { return [] }
        return getHeightRecords(for: baby)
    }
    
    var headCircumferenceRecords: [GrowthRecord] {
        guard let baby = babyProfile else { return [] }
        return getHeadCircumferenceRecords(for: baby)
    }
    
    func recentWeightGain() -> Double? {
        guard let baby = babyProfile else { return nil }
        return recentWeightGain(for: baby)
    }
    
    func recentHeightGain() -> Double? {
        guard let baby = babyProfile else { return nil }
        return recentHeightGain(for: baby)
    }
    
    // MARK: - Helper Functions
    
    func formatWeight(_ weight: Double) -> String {
        return String(format: "%.1f kg", weight)
    }
    
    func formatHeight(_ height: Double) -> String {
        return String(format: "%.0f cm", height)
    }
    
    func formatHeadCircumference(_ circumference: Double) -> String {
        return String(format: "%.1f cm", circumference)
    }
}
