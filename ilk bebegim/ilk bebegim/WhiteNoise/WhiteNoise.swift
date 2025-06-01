//
//  WhiteNoise.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation

struct WhiteNoise: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let audioFileName: String
    let icon: String // SF Symbol name
    let color: String // Hex color
    var isFavorite: Bool = false
    var isLooping: Bool = true // Beyaz gürültü genelde loop
    
    // Örnek beyaz gürültü sesleri
    static let sampleNoises: [WhiteNoise] = [
        WhiteNoise(
            title: "Beyaz Gürültü",
            description: "Klasik beyaz gürültü, odaklanma için ideal",
            audioFileName: "beyaz.mp3",
            icon: "waveform",
            color: "#E0E0E0"
        ),
        WhiteNoise(
            title: "Pembe Gürültü",
            description: "Daha yumuşak, uyku için mükemmel",
            audioFileName: "pembe.mp3",
            icon: "waveform.path",
            color: "#FFB6C1"
        ),
        WhiteNoise(
            title: "Kahverengi Gürültü",
            description: "Derin, sakinleştirici gürültü",
            audioFileName: "kahverengi.mp3",
            icon: "waveform.path.ecg",
            color: "#8B4513"
        ),
        WhiteNoise(
            title: "Kalp Atışı",
            description: "Anne karnındaki rahatlatıcı ses",
            audioFileName: "kalp.mp3",
            icon: "heart.fill",
            color: "#FF6B6B"
        ),
        WhiteNoise(
            title: "Yağmur Sesi",
            description: "Sakinleştirici yağmur damlaları",
            audioFileName: "rainy.mp3",
            icon: "cloud.rain.fill",
            color: "#4A90E2"
        ),
        WhiteNoise(
            title: "Okyanus Dalgaları",
            description: "Huzur veren dalga sesleri",
            audioFileName: "okyanus.mp3",
            icon: "water.waves",
            color: "#0077BE"
        )
    ]
}
