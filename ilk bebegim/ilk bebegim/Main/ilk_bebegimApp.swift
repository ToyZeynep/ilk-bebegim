//
//  ilk_bebegimApp.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import FirebaseRemoteConfig

@main
struct IlkBebegimApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    init() {
        FirebaseApp.configure()
        MobileAds.shared.start { status in
            print("AdMob başlatıldı. Status: \(status)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}
