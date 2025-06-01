//
//  GrowthRecordDetailCard.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct GrowthRecordDetailCard: View {
    let record: GrowthRecord
    @ObservedObject var viewModel: GrowthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.formattedDate)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text(record.ageText)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.darkGray))
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.deleteGrowthRecord(record)
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
            }
            
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
            
            // Notes
            if let notes = record.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notlar:")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Text(notes)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.darkGray))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}
