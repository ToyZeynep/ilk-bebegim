//
//  RemoteConfigManager.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 13.06.2025.
//

import Foundation
import Firebase

class RemoteConfigManager: ObservableObject {
    @Published var isSoundsTabEnabled: Bool = false
    @Published var isLoading: Bool = true
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        setupRemoteConfig()
        fetchRemoteConfig()
    }
    
    private func setupRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // Development için, production'da 3600 yap
        remoteConfig.configSettings = settings
        
        // Default değerler - NSNumber olarak sarmalı
        remoteConfig.setDefaults([
            "sounds_tab_enabled": NSNumber(value: false)  // ← Düzeltme burada
        ])
    }
    
    func fetchRemoteConfig() {
        isLoading = true
        
        remoteConfig.fetch { [weak self] status, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if status == .success {
                    self?.remoteConfig.activate { _, _ in
                        self?.updateValues()
                    }
                } else {
                    print("Remote Config fetch error: \(error?.localizedDescription ?? "Unknown error")")
                    // Hata durumunda default değerleri kullan
                    self?.updateValues()
                }
            }
        }
    }
    
    private func updateValues() {
        DispatchQueue.main.async {
            self.isSoundsTabEnabled = self.remoteConfig.configValue(forKey: "sounds_tab_enabled").boolValue
            print("Sounds tab enabled: \(self.isSoundsTabEnabled)")
        }
    }
}
