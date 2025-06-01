//
//  MeasurementBadgeView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 1.06.2025.
//

import SwiftUI

struct MeasurementBadgeView: View {
    let value: String
    let color: String
    
    var body: some View {
        Text(value)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color(hex: color))
            )
    }
}
