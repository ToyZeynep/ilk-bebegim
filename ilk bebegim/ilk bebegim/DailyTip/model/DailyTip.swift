//
//  DailyTip.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//


import Foundation
import FirebaseFirestore

struct DailyTip: Identifiable, Codable {
    @DocumentID var id: String?
    var index: Int           // Sıra numarası (0, 1, 2, 3...)
    var category: String     // Kategori (beslenme, uyku, gelişim, sağlık vb.)
    var title: String        // Kısa başlık
    var content: String      // Ana içerik
    var tips: [String]       // İpucu listesi (opsiyonel)
    var ageRange: AgeRange   // Hangi yaş aralığı için
    var isActive: Bool       // Aktif mi (yayında mı)
    var createdAt: Date      // Oluşturulma tarihi
    var updatedAt: Date      // Güncellenme tarihi
    
    init(index: Int, category: String, title: String, content: String, tips: [String] = [], ageRange: AgeRange = .all, isActive: Bool = true) {
        self.index = index
        self.category = category
        self.title = title
        self.content = content
        self.tips = tips
        self.ageRange = ageRange
        self.isActive = isActive
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum AgeRange: String, Codable, CaseIterable {
    case newborn = "0-1 ay"      // Yenidoğan
    case infant = "1-6 ay"       // Bebek
    case older = "6+ ay"         // Büyük bebek
    case all = "Tüm yaşlar"     // Genel
    
    var description: String {
        return self.rawValue
    }
}

enum TipCategory: String, CaseIterable {
    case feeding = "beslenme"
    case sleep = "uyku"
    case development = "gelişim"
    case health = "sağlık"
    case care = "bakım"
    case play = "oyun"
    case safety = "güvenlik"
    case general = "genel"
    
    var emoji: String {
        switch self {
        case .feeding: return "🍼"
        case .sleep: return "😴"
        case .development: return "🧠"
        case .health: return "🏥"
        case .care: return "🤱"
        case .play: return "🧸"
        case .safety: return "🛡️"
        case .general: return "💡"
        }
    }
    
    var displayName: String {
        switch self {
        case .feeding: return "Beslenme"
        case .sleep: return "Uyku"
        case .development: return "Gelişim"
        case .health: return "Sağlık"
        case .care: return "Bakım"
        case .play: return "Oyun"
        case .safety: return "Güvenlik"
        case .general: return "Genel"
        }
    }
}
