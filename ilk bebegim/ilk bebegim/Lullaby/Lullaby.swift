//
//  Lullaby.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation

struct Lullaby: Identifiable, Codable {
    var id = UUID()
    let title: String
    let lyrics: String
    let audioFileName: String? // Optional - bazılarında ses olmayabilir
    let category: String? // İleride kategoriler için
    var isFavorite: Bool = false
    let duration: TimeInterval? // Ses dosyası süresi (saniye)
    
    // Örnek ninniler için static func
    static let sampleLullabies: [Lullaby] = [
        Lullaby(
            title: "Dandini Dandini Dastana",
            lyrics: """
            Dandini dandini dastana
            Danalar girmiş bostana
            Kov bostancı danayı
            Yesin patlıcan turpayı
            
            Dandini dandini dastana
            Danalar girmiş bostana
            Kov bostancı danayı
            Yesin patlıcan turpayı
            """,
            audioFileName: "lullaby.mp3", // Test dosyan
            category: "Geleneksel",
            duration: 120.0
        ),
        Lullaby(
            title: "Uyusun da Büyüsün",
            lyrics: """
            Uyusun da büyüsün
            Annesinin ak sütün
            Em oğlum em
            
            Büyü de gel yanıma
            Tutun beni elimden
            Em oğlum em
            
            Dandini dandini danalar
            Girmiş bahçemde hanalar
            Em oğlum em
            """,
            audioFileName: "lullaby.mp3",
            category: "Geleneksel",
            duration: 95.0
        ),
        Lullaby(
            title: "Eee Eee Ninnisi",
            lyrics: """
            Eee eee oğlum eee
            Büyü de baban eve gele
            
            Getire kuzu dede
            Pişire ahu nene
            
            Eee eee oğlum eee
            Büyü de baban eve gele
            """,
            audioFileName: nil, // Bu ninnide ses yok
            category: "Geleneksel",
            duration: nil
        )
    ]
}
