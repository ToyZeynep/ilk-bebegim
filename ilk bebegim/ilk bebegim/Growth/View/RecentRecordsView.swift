//
//  RecentRecordsView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct RecentRecordsView: View {
    let babyProfile: BabyProfile
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Son Kayıtlar")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                Spacer()
                
                NavigationLink(destination: AllRecordsView(viewModel: viewModel, babyProfile: babyProfile)) {
                    Text("Tümü")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                }
            }
            
            ForEach(viewModel.getGrowthRecords(for: babyProfile).suffix(3).reversed(), id: \.id) { record in
                GrowthRecordRowView(record: record, viewModel: viewModel)
            }
        }
    }
}
