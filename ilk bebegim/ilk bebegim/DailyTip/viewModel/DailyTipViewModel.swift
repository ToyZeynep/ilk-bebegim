//
//  DailyTipViewModel.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation
import FirebaseFirestore

class DailyTipViewModel: ObservableObject {
    @Published var todaysTip: DailyTip?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    private let firstLaunchDateKey = "FirstLaunchDate"
    private let lastTipDateKey = "LastTipDate"
    
    func fetchDailyTip() {
        let today = Calendar.current.startOfDay(for: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        // Son tip gösterilme tarihi kontrol et
        let lastTipDate = userDefaults.string(forKey: lastTipDateKey)
        
        // Bugün zaten tip gösterildiyse, mevcut tipi göster
        if lastTipDate == todayString, let existingTip = todaysTip {
            return
        }
        
        // Kullanıcının uygulama yaşını hesapla
        let userAppAge = calculateUserAppAge()
        print("📅 Kullanıcı app yaşı: \(userAppAge) gün")
        
        // O güne ait tipi getir
        loadTipForDay(userAppAge, dateString: todayString)
    }
    
    private func calculateUserAppAge() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        
        // İlk kullanım tarihi var mı?
        if let firstLaunchString = userDefaults.string(forKey: firstLaunchDateKey),
           let firstLaunchDate = DateFormatter().dateFromString(firstLaunchString) {
            
            // İlk kullanım tarihinden bugüne kadar geçen gün sayısı
            let daysBetween = Calendar.current.dateComponents([.day], from: firstLaunchDate, to: today).day ?? 0
            return max(0, daysBetween)
            
        } else {
            // İlk kullanım - tarihi kaydet
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayString = dateFormatter.string(from: today)
            userDefaults.set(todayString, forKey: firstLaunchDateKey)
            
            print("🎉 İlk kullanım kaydedildi: \(todayString)")
            return 0
        }
    }
    
    private func loadTipForDay(_ dayIndex: Int, dateString: String) {
        isLoading = true
        errorMessage = nil
        
        print("🔍 Gün \(dayIndex) için tip aranıyor...")
        
        // Tüm tipleri index'e göre sırala (isActive filtresi kaldırıldı)
        db.collection("dailyTips")
            .order(by: "index")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error fetching tips: \(error.localizedDescription)")
                    self.handleError("İpucu yüklenirken hata oluştu")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("❌ Hiç tip bulunamadı")
                    self.handleError("Henüz ipucu eklenmemiş")
                    return
                }
                
                // Aktif tipleri filtrele (kod tarafında)
                let activeTips = documents.compactMap { doc -> QueryDocumentSnapshot? in
                    do {
                        let tip = try doc.data(as: DailyTip.self)
                        return tip.isActive ? doc : nil
                    } catch {
                        return nil
                    }
                }
                
                guard !activeTips.isEmpty else {
                    print("❌ Hiç aktif tip bulunamadı")
                    self.handleError("Henüz aktif ipucu yok")
                    return
                }
                
                // Döngüsel index hesapla
                let totalTips = activeTips.count
                let loopedIndex = dayIndex % totalTips
                
                print("📊 Toplam \(totalTips) aktif tip var, döngüsel index: \(loopedIndex)")
                
                // Sıralı array'den tip al
                let tipDoc = activeTips[loopedIndex]
                self.processTip(tipDoc, dayIndex: dayIndex, dateString: dateString)
            }
    }
    
    private func findTipWithLoop(dayIndex: Int, dateString: String) {
        // Tüm tiplerin sayısını öğren ve modulo ile döngüsel index bul
        db.collection("dailyTips")
            .order(by: "day")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error fetching tips for loop: \(error.localizedDescription)")
                    self.handleError("İpucu yüklenirken hata oluştu")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("❌ Hiç tip bulunamadı")
                    self.handleError("Henüz ipucu eklenmemiş")
                    return
                }
                
                // Döngüsel index hesapla
                let totalTips = documents.count
                let loopedIndex = dayIndex % totalTips
                
                print("📊 Toplam \(totalTips) tip var, döngüsel index: \(loopedIndex)")
                
                // Index'e göre sıralı tip al (0, 1, 2, 3... sırasında)
                if loopedIndex < documents.count {
                    let tipDoc = documents[loopedIndex]
                    self.processTip(tipDoc, dayIndex: loopedIndex, dateString: dateString)
                } else {
                    // Son çare: İlk tipi al
                    self.processTip(documents[0], dayIndex: 0, dateString: dateString)
                }
            }
    }
    
    private func processTip(_ document: QueryDocumentSnapshot, dayIndex: Int, dateString: String) {
        do {
            let tip = try document.data(as: DailyTip.self)
            
            DispatchQueue.main.async {
                self.todaysTip = tip
                self.isLoading = false
                
                // Son gösterilme tarihini kaydet
                self.userDefaults.set(dateString, forKey: self.lastTipDateKey)
                
                print("✅ Tip yüklendi (Gün \(dayIndex)): \(tip.title)")
                print("📂 Kategori: \(tip.category)")
                print("🔢 Tip Index: \(tip.index)")
            }
        } catch {
            print("❌ Error parsing tip: \(error.localizedDescription)")
            self.handleError("İpucu işlenirken hata oluştu")
        }
    }
    
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.isLoading = false
        }
    }
    
    // Debug fonksiyonları
    func getUserAppInfo() -> String {
        let appAge = calculateUserAppAge()
        let firstLaunch = userDefaults.string(forKey: firstLaunchDateKey) ?? "Bilinmiyor"
        return "App yaşı: \(appAge) gün, İlk kullanım: \(firstLaunch)"
    }
    
    // Test için: Sonraki günün tipini göster
    func previewNextTip() {
        let nextDay = calculateUserAppAge() + 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        
        print("🔮 Yarının tipi (Gün \(nextDay)) getiriliyor...")
        loadTipForDay(nextDay, dateString: todayString)
    }
}

// Helper extension
extension DateFormatter {
    func dateFromString(_ string: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd"
        return self.date(from: string)
    }
}
