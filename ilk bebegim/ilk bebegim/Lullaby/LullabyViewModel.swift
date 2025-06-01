//
//  LullabyViewModel.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation
import AVFoundation

class LullabyViewModel: NSObject, ObservableObject {
    @Published var lullabies: [Lullaby] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Audio player properties
    @Published var currentlyPlaying: Lullaby? = nil
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private(set) var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    override init() {
        super.init()
        loadLullabies()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup error: \(error)")
        }
    }
    
    private func loadLullabies() {
        isLoading = true
        
        // Simülasyon - gerçekte API'den gelecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.lullabies = Lullaby.sampleLullabies
            self.isLoading = false
        }
    }
    
    // MARK: - Audio Controls
    
    func playLullaby(_ lullaby: Lullaby) {
        guard let audioFileName = lullaby.audioFileName else {
            errorMessage = "Bu ninni için ses dosyası bulunmuyor"
            return
        }
        
        // Eğer aynı ninni çalıyorsa pause/resume
        if currentlyPlaying?.id == lullaby.id {
            if isPlaying {
                pauseAudio()
            } else {
                resumeAudio()
            }
            return
        }
        
        // Yeni ninni çal
        stopAudio()
        currentlyPlaying = lullaby
        
        guard let path = Bundle.main.path(forResource: audioFileName.replacingOccurrences(of: ".mp3", with: ""), ofType: "mp3") else {
            errorMessage = "Ses dosyası bulunamadı"
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            duration = audioPlayer?.duration ?? 0
            
            audioPlayer?.play()
            isPlaying = true
            startTimer()
            
        } catch {
            errorMessage = "Ses çalma hatası: \(error.localizedDescription)"
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func resumeAudio() {
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentlyPlaying = nil
        currentTime = 0
        duration = 0
        stopTimer()
    }
    
    func seekToTime(_ time: TimeInterval) {
        guard let player = audioPlayer else { return }
        let newTime = max(0, min(time, duration))
        player.currentTime = newTime
        currentTime = newTime
    }
    
    func seekForward(_ seconds: TimeInterval = 15) {
        let newTime = min(currentTime + seconds, duration)
        seekToTime(newTime)
    }
    
    func seekBackward(_ seconds: TimeInterval = 15) {
        let newTime = max(currentTime - seconds, 0)
        seekToTime(newTime)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.currentTime = self.audioPlayer?.currentTime ?? 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Favorites
    
    func toggleFavorite(for lullaby: Lullaby) {
        if let index = lullabies.firstIndex(where: { $0.id == lullaby.id }) {
            lullabies[index].isFavorite.toggle()
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension LullabyViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.stopAudio()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        DispatchQueue.main.async {
            self.errorMessage = "Ses çözme hatası: \(error?.localizedDescription ?? "Bilinmeyen hata")"
            self.stopAudio()
        }
    }
}
