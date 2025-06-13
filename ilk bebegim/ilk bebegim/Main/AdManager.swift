import Foundation
import GoogleMobileAds
import SwiftUI

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    @Published var interstitialAd: InterstitialAd?
    
    private let bannerAdUnitID = "ca-app-pub-7359263265391774/1264785059"
    private let interstitialAdUnitID = "ca-app-pub-7359263265391774/4167707611"
    
    @Published var questionDetailViewCount = 0
    private let interstitialTriggerCount = 7
    
    override init() {
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.loadInterstitialAd()
        }
    }
    
    private func loadInterstitialAd() {
        let request = Request()
        InterstitialAd.load(with: interstitialAdUnitID, request: request) { [weak self] ad, error in
            DispatchQueue.main.async {
                if let ad = ad {
                    self?.interstitialAd = ad
                    self?.interstitialAd?.fullScreenContentDelegate = self
                }
            }
        }
    }
    
    func trackQuestionDetailView() {
        questionDetailViewCount += 1
        print("📊 Soru detay sayısı: \(questionDetailViewCount)")
        
        if questionDetailViewCount % interstitialTriggerCount == 0 {
            print("🎯 Interstitial tetikleniyor! (\(questionDetailViewCount). soru)")
            showInterstitial()
        }
    }
    
    private func showInterstitial() {
        guard let interstitialAd = interstitialAd,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        interstitialAd.present(from: rootViewController)
    }
    
    func getBannerAdUnitID() -> String {
        return bannerAdUnitID
    }
}

extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        if ad is InterstitialAd {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadInterstitialAd()
            }
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        // Handle error if needed
    }
}

struct AdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = AdManager.shared.getBannerAdUnitID()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        uiView.load(Request())
    }
}

struct QuestionListBanner: View {
    let questionIndex: Int
    
    var body: some View {
        if (questionIndex + 1) % 10 == 0 {
            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Text("Reklam")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(3)
                }
                
                AdBannerView()
                    .frame(height: 50)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            .padding(.vertical, 8)
        }
    }
}

struct BottomBannerView: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Spacer()
                Text("Reklam")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(2)
            }
            .padding(.horizontal, 12)
            
            AdBannerView()
                .frame(height: 50)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background(Color.white.opacity(0.95))
    }
}
