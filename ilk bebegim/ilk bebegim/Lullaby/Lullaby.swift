//
//  Lullaby.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation

struct Lullaby: Identifiable, Codable {
    let id = UUID()
    let title: String
    let lyrics: String
    let audioFileName: String?
    let category: String?
    var isFavorite: Bool = false
    
    static let sampleLullabies: [Lullaby] = [
        Lullaby(
            title: "Yıldızlı Geceler",
            lyrics: "",
            audioFileName: "ninni1.mp3",
            category: "Geleneksel"
        ),
        Lullaby(
            title: "Ballı Rüyalar",
            lyrics: "",
            audioFileName: "ninni2.mp3",
            category: "Geleneksel"
        ),
        Lullaby(
            title: "Sessiz Gece",
            lyrics: "",
            audioFileName: "ninni3.mp3",
            category: "Geleneksel"
        ),
        Lullaby(
            title: "Sevginin Ezgisi",
            lyrics: "",
            audioFileName: "ninni4.mp3",
            category: "Geleneksel"
        ),
        Lullaby(
            title: "Tatlı Düşler",
            lyrics: "",
            audioFileName: "melek.mp3",
            category: "Geleneksel"
        ),
        Lullaby(
            title: "Geceye Merhaba",
            lyrics: "",
            audioFileName: "kovanbal.mp3",
            category: "Geleneksel"
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
            audioFileName: nil,
            category: "Geleneksel"
        ),
        Lullaby(
            title: "Rüya Bahçesi",
            lyrics: """
            Gel uyu kuzum gel uyu
            Rüya bahçesine gidiyoruz
            Orada pembe bulutlar var
            Peri masalları dinliyoruz

            La la la la ninni ninni
            Tatlı düşler seni bekliyor
            Ay teyze de geliyor yanına
            Sevgiyle sarıp sarmalıyor

            Büyüyünce anlayacaksın
            Bu ninniyi sen de söyleyeceksin
            Şimdilik sadece dinle
            Gözlerini yavaşça kapat

            Ninni ninni oğlum benim
            Ninni ninni kızım benim
            Sabaha kadar uyusun
            Annemin kalbi seninle
            """,
            audioFileName: nil,
            category: "Orijinal"
        ),
        Lullaby(
            title: "Yıldızların Fısıltısı",
            lyrics: """
            Uyu minik yavrum uyu
            Yıldızlar sana bakıyor
            Ay ışığı pencereden
            Tatlı rüyalar getiriyor

            Ninni ninni canım benim
            Gözlerin yavaş kapansın
            Bulutlar üstünde uçarak
            Melek rüyalar göresin

            Kuşlar da uyumuş yuvasında
            Çiçekler kapamış gözlerini
            Sen de uyu sevgilim
            Annen söylüyor ninnisini
            """,
            audioFileName: nil,
            category: "Orijinal"
        ),
        Lullaby(
            title: "Ayışığında Ninni",
            lyrics: """
            Ay ışığı dolaşıyor
            Bebeğimin yüzüne
            Melekler fısıldıyor
            Kulağına tatlı söz

            Ninni ninni yavrucuğum
            Gece sana şarkı söylüyor
            Yıldızlar parlıyorken
            Rüyalar seni bekliyor

            Sabah gelince uyanacaksın
            Güneş yüzün okşayacak
            Şimdilik sadece uyu
            Annenin kalbinde yat
            """,
            audioFileName: nil,
            category: "Orijinal"
        )
    ]
}
