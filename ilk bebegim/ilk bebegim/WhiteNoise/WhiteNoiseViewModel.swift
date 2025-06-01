//
//  WhiteNoiseViewModel.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import Foundation
import AVFoundation

class WhiteNoiseViewModel: NSObject, ObservableObject {
    @Published var whiteNoises: [WhiteNoise] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Audio player properties
    @Published var currentlyPlaying: WhiteNoise? = nil
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 0.5
    
    // Timer properties
    @Published var timerMinutes: Int = 0 // 0 = süresiz
    @Published var remainingTime: TimeInterval = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var sleepTimer: Timer?
    private var countdownTimer: Timer?
    
    override init() {
        super.init()
        loadWhiteNoises()
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
    
    private func loadWhiteNoises() {
        isLoading = true
        
        // Simülasyon - gerçekte API'den gelecek
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.whiteNoises = WhiteNoise.sampleNoises
            self.isLoading = false
        }
    }
    
    // MARK: - Audio Controls
    
    func playWhiteNoise(_ noise: WhiteNoise) {
        // Eğer aynı ses çalıyorsa pause/resume
        if currentlyPlaying?.id == noise.id {
            if isPlaying {
                pauseAudio()
            } else {
                resumeAudio()
            }
            return
        }
        
        // Yeni ses çal
        stopAudio()
        currentlyPlaying = noise
        
        guard let path = Bundle.main.path(forResource: noise.audioFileName.replacingOccurrences(of: ".mp3", with: ""), ofType: "mp3") else {
            errorMessage = "Ses dosyası bulunamadı"
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = noise.isLooping ? -1 : 0 // -1 = sonsuz loop
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            
            audioPlayer?.play()
            isPlaying = true
            
            // Timer varsa başlat
            if timerMinutes > 0 {
                startSleepTimer()
            }
            
        } catch {
            errorMessage = "Ses çalma hatası: \(error.localizedDescription)"
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        pauseSleepTimer()
    }
    
    func resumeAudio() {
        audioPlayer?.play()
        isPlaying = true
        resumeSleepTimer()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentlyPlaying = nil
        stopSleepTimer()
    }
    
    func setVolume(_ newVolume: Float) {
        volume = newVolume
        audioPlayer?.volume = volume
    }
    
    // MARK: - Timer Functions
    
    func setTimer(minutes: Int) {
        timerMinutes = minutes
        remainingTime = TimeInterval(minutes * 60)
    }
    
    private func startSleepTimer() {
        stopSleepTimer()
        remainingTime = TimeInterval(timerMinutes * 60)
        
        sleepTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerMinutes * 60), repeats: false) { _ in
            DispatchQueue.main.async {
                self.stopAudio()
            }
        }
        
        // Countdown timer
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopSleepTimer()
            }
        }
    }
    
    private func pauseSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func resumeSleepTimer() {
        if timerMinutes > 0 && remainingTime > 0 {
            sleepTimer = Timer.scheduledTimer(withTimeInterval: remainingTime, repeats: false) { _ in
                DispatchQueue.main.async {
                    self.stopAudio()
                }
            }
            
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    self.stopSleepTimer()
                }
            }
        }
    }
    
    private func stopSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = nil
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingTime = 0
    }
    
    // MARK: - Favorites
    
    func toggleFavorite(for noise: WhiteNoise) {
        if let index = whiteNoises.firstIndex(where: { $0.id == noise.id }) {
            whiteNoises[index].isFavorite.toggle()
        }
    }
    
    // MARK: - Helper Functions
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - AVAudioPlayerDelegate

extension WhiteNoiseViewModel: AVAudioPlayerDelegate {
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
