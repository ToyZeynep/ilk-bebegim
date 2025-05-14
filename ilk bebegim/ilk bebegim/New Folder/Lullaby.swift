//
//  Lullaby.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 14.05.2025.
//

import SwiftUI
import AVFoundation
import FirebaseFirestore

struct Lullaby: Identifiable {
    var id = UUID()
    var title: String
    var url: String
    var duration: String
}

struct LullabyListView: View {
    @State private var lullabies: [Lullaby] = []
    @State private var player: AVPlayer?
    @State private var nowPlaying: String?

    var body: some View {
        NavigationView {
            List(lullabies) { lullaby in
                VStack(alignment: .leading, spacing: 6) {
                    Text(lullaby.title)
                        .font(.headline)

                    Text("Süre: \(lullaby.duration)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    if nowPlaying == lullaby.title {
                        Text("Şu an çalıyor...")
                            .font(.caption)
                            .foregroundColor(.green)

                        Button("Durdur") {
                            stopPlayback()
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 6)
                .onTapGesture {
                    if nowPlaying != lullaby.title {
                        playLullaby(urlString: lullaby.url)
                        nowPlaying = lullaby.title
                    }
                }
            }
            .navigationTitle("Ninniler")
        }
        .onAppear {
            fetchLullabies()
        }
    }

    // MARK: - Ninni Çalma
    func playLullaby(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL: \(urlString)")
            return
        }

        print("Çalınan URL: \(urlString)")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession Hatası: \(error.localizedDescription)")
        }

        player = AVPlayer(url: url)
        player?.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Oynatma durumu (rate): \(player?.rate ?? 0)")
            if player?.rate == 0 {
                print("⚠️ Ses çalmıyor olabilir.")
            }
        }
    }

    // MARK: - Durdurma
    func stopPlayback() {
        player?.pause()
        nowPlaying = nil
    }

    // MARK: - Firestore'dan Ninnileri Çek
    func fetchLullabies() {
        let db = Firestore.firestore()
        db.collection("lullabies").order(by: "order").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Firestore verisi alınamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                return
            }

            self.lullabies = documents.compactMap { doc in
                let data = doc.data()
                return Lullaby(
                    title: data["title"] as? String ?? "Bilinmeyen",
                    url: data["url"] as? String ?? "",
                    duration: data["duration"] as? String ?? ""
                )
            }

            print("🎵 Toplam \(self.lullabies.count) ninni yüklendi.")
        }
    }
}
