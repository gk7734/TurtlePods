//
//  PosturePercentageRow.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct PosturePercentageRow: View {
    let posture: SleepPostureManager.SleepPosture
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(posture.description)
                Spacer()
                Text(String(format: "%.1f%%", percentage))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(percentage) * geometry.size.width / 100, geometry.size.width), height: 8)
                        .foregroundColor(.blue)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
}
