//
//  GrowthRecord.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation

struct GrowthRecord: Identifiable, Codable {
    let id = UUID()
    let babyId: UUID
    let date: Date
    let ageInDays: Int
    let weight: Double?
    let height: Double?
    let headCircumference: Double?
    let notes: String?
    let photoData: Data?
    
    var ageText: String {
        let months = ageInDays / 30
        let days = ageInDays % 30
        
        if months == 0 {
            return "\(ageInDays) gün"
        } else if days == 0 {
            return "\(months) ay"
        } else {
            return "\(months) ay \(days) gün"
        }
    }
    
    // Tarih formatı
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

struct BabyProfile: Identifiable, Codable {
    let id: UUID
    let birthDate: Date
    let name: String
    let gender: BabyGender
    
    init(name: String, birthDate: Date, gender: BabyGender) {
        self.id = UUID()
        self.name = name
        self.birthDate = birthDate
        self.gender = gender
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let existingId = try? container.decode(UUID.self, forKey: .id) {
            self.id = existingId
        } else {
            self.id = UUID()
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.birthDate = try container.decode(Date.self, forKey: .birthDate)
        self.gender = try container.decode(BabyGender.self, forKey: .gender)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(gender, forKey: .gender)
    }
    
    enum CodingKeys: CodingKey {
        case id, name, birthDate, gender
    }
    
    var ageInDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: birthDate, to: Date())
        return components.day ?? 0
    }
    
    var ageText: String {
        let days = ageInDays
        let months = days / 30
        let remainingDays = days % 30
        
        if months == 0 {
            return "\(days) günlük"
        } else if remainingDays == 0 {
            return "\(months) aylık"
        } else {
            return "\(months) ay \(remainingDays) günlük"
        }
    }
}
enum BabyGender: String, CaseIterable, Codable {
    case male = "Erkek"
    case female = "Kız"
    
    var icon: String {
        switch self {
        case .male: return "figure.child"
        case .female: return "figure.child"
        }
    }
    
    var color: String {
        switch self {
        case .male: return "#4A90E2"
        case .female: return "#FF6B9D"
        }
    }
}
