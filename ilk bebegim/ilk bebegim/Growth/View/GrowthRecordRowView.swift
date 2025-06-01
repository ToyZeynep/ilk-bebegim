//
//  GrowthRecordRowView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct GrowthRecordRowView: View {
    let record: GrowthRecord
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Date
            VStack(alignment: .leading, spacing: 2) {
                Text(record.formattedDate)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                Text(record.ageText)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Color(.darkGray))
            }
            
            Spacer()
            
            // Measurements
            HStack(spacing: 12) {
                if let weight = record.weight {
                    MeasurementBadgeView(
                        value: viewModel.formatWeight(weight),
                        color: "#FF6B6B"
                    )
                }
                
                if let height = record.height {
                    MeasurementBadgeView(
                        value: viewModel.formatHeight(height),
                        color: "#4A90E2"
                    )
                }
                
                if let headCirc = record.headCircumference {
                    MeasurementBadgeView(
                        value: viewModel.formatHeadCircumference(headCirc),
                        color: "#87CEEB"
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 4, y: 1)
        )
    }
}
